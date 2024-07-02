package test

import (
	"context"
	"encoding/json"
	"fmt"
	"io"
	"net"
	"net/http"
	"os"
	"testing"
	"time"

	"github.com/gruntwork-io/terratest/modules/docker"
	"github.com/gruntwork-io/terratest/modules/retry"
	"github.com/gruntwork-io/terratest/modules/terraform"
	amqp "github.com/rabbitmq/amqp091-go"
	"github.com/stretchr/testify/assert"
)

const (
	vaultUrl   = "http://localhost:8200"
	vaultToken = "test"
	dbHost     = "localhost"
	dbPort     = "5672"
)

func TestTerragrunt(t *testing.T) {
	workDir := "../envs/dev"
	dockerOpts := &docker.Options{
		WorkingDir: workDir,
		EnvVars: map[string]string{
			"COMPOSE_FILE": "docker-compose.yaml",
		},
	}

	_ = os.Remove(workDir + "/terraform.tfstate")

	defer docker.RunDockerCompose(t, dockerOpts, "down")
	docker.RunDockerCompose(t, dockerOpts, "up", "-d")

	waitForQueue(t, dbHost, dbPort)
	waitForVault(t)

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir:    workDir,
		TerraformBinary: "terragrunt",
		EnvVars: map[string]string{
			"TF_ENCRYPTION": `key_provider "pbkdf2" "mykey" {passphrase = "somekeynotverysecure"}`,
		},
	})

	defer terraform.Destroy(t, terraformOptions)
	terraform.Apply(t, terraformOptions)

	queueUser := "producer"
	secret, err := readVaultSecret(vaultUrl, vaultToken, fmt.Sprintf("secret/data/env/dev/rabbitmq/users/%s", queueUser))
	assert.NoError(t, err)
	assert.Contains(t, secret, "password")
	queuePass := secret["password"].(string)

	config := RabbitMQConfig{
		Username: queueUser,
		Password: queuePass,
		Host:     "localhost",
		Port:     "5672",
		Vhost:    "/dev",
	}

	err = SendMessageToRabbitMQ(config, "hermes", "Hello, RabbitMQ!")
	assert.NoError(t, err)
}

func readVaultSecret(vaultAddr, token, secretPath string) (map[string]interface{}, error) {
	url := fmt.Sprintf("%s/v1/%s", vaultAddr, secretPath)

	req, err := http.NewRequest("GET", url, nil)
	if err != nil {
		return nil, fmt.Errorf("failed to create request: %v", err)
	}

	req.Header.Set("X-Vault-Token", token)
	client := &http.Client{
		Timeout: 1 * time.Second,
	}
	resp, err := client.Do(req)
	if err != nil {
		return nil, fmt.Errorf("failed to send request: %v", err)
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		return nil, fmt.Errorf("unexpected response status: %s", resp.Status)
	}
	body, err := io.ReadAll(resp.Body)
	if err != nil {
		return nil, fmt.Errorf("failed to read response body: %v", err)
	}

	var responseData map[string]interface{}
	if err := json.Unmarshal(body, &responseData); err != nil {
		return nil, fmt.Errorf("failed to parse JSON response: %v", err)
	}

	data, ok := responseData["data"].(map[string]interface{})
	if !ok {
		return nil, fmt.Errorf("unexpected response structure")
	}

	secretData, ok := data["data"].(map[string]interface{})
	if !ok {
		return nil, fmt.Errorf("unexpected secret data structure")
	}

	return secretData, nil
}

func waitForVault(t *testing.T) {
	retry.DoWithRetry(t, "Waiting for vault service", 45, 1*time.Second, func() (string, error) {
		resp, err := http.Get(vaultUrl + "/ui/")
		if err != nil {
			return "", err
		}
		defer resp.Body.Close()

		if resp.StatusCode != 200 {
			return "", fmt.Errorf("expected HTTP status 200 but got %d", resp.StatusCode)
		}

		return "Service is available", nil
	})
}

func waitForQueue(t *testing.T, host string, port string) {
	retry.DoWithRetry(t, "Waiting for database service", 45, 1*time.Second, func() (string, error) {
		conn, err := net.DialTimeout("tcp", fmt.Sprintf("%s:%s", host, port), 1*time.Second)
		if err != nil {
			return "", fmt.Errorf("failed to connect to MySQL port: %v", err)
		}
		defer conn.Close()
		return "RabbitMQ is available", nil
	})
}

func SendMessageToRabbitMQ(config RabbitMQConfig, queueName, message string) error {
	amqpURL := "amqp://" + config.Username + ":" + config.Password + "@" + config.Host + ":" + config.Port + config.Vhost

	// Establish a connection to RabbitMQ server
	conn, err := amqp.Dial(amqpURL)
	if err != nil {
		return err
	}
	defer conn.Close()

	// Create a channel
	ch, err := conn.Channel()
	if err != nil {
		return err
	}
	defer ch.Close()

	// Declare a queue to ensure it exists
	_, err = ch.QueueDeclare(
		queueName, // queue name
		false,     // durable
		false,     // delete when unused
		false,     // exclusive
		false,     // no-wait
		nil,       // arguments
	)
	if err != nil {
		return err
	}

	ctx, cancel := context.WithTimeout(context.Background(), 30*time.Second)
	defer cancel()
	err = ch.PublishWithContext(
		ctx,
		"",        // exchange
		queueName, // routing key
		false,     // mandatory
		false,     // immediate
		amqp.Publishing{
			ContentType: "text/plain",
			Body:        []byte(message),
		})
	if err != nil {
		return err
	}

	return nil
}

type RabbitMQConfig struct {
	Username string
	Password string
	Host     string
	Port     string
	Vhost    string
}
