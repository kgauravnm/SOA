import com.rabbitmq.client.*;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.util.concurrent.TimeoutException;

public class RabbitMqConsumer {

    private static final String QUEUE_NAME = "my_queue";
    private static final String RABBITMQ_HOST = "localhost";

    public static void main(String[] args) {
        try {
            // Establish connection
            ConnectionFactory factory = new ConnectionFactory();
            factory.setHost(RABBITMQ_HOST);
            factory.setUsername("guest");
            factory.setPassword("guest");

            Connection connection = factory.newConnection();
            Channel channel = connection.createChannel();

            // Declare queue (in case it's not already created)
            channel.queueDeclare(QUEUE_NAME, true, false, false, null);
            System.out.println("Waiting for messages...");

            DeliverCallback deliverCallback = (consumerTag, delivery) -> {
                long deliveryTag = delivery.getEnvelope().getDeliveryTag();
                String message = new String(delivery.getBody(), StandardCharsets.UTF_8);
                System.out.println("Received message: " + message);

                // Process the message and send ACK with retry
                processAndAcknowledgeMessage(channel, deliveryTag);
            };

            // Enable manual acknowledgment (autoAck=false)
            channel.basicConsume(QUEUE_NAME, false, deliverCallback, consumerTag -> {});

        } catch (IOException | TimeoutException e) {
            e.printStackTrace();
        }
    }

    private static void processAndAcknowledgeMessage(Channel channel, long deliveryTag) {
        int maxRetries = 5;
        int retryCount = 0;
        int backoffMillis = 2000;

        while (retryCount < maxRetries) {
            try {
                // Simulate message processing
                Thread.sleep(1000);
                System.out.println("Processing completed, sending ACK...");

                // Send acknowledgment
                channel.basicAck(deliveryTag, false);
                System.out.println("ACK sent successfully.");
                return;

            } catch (IOException e) {
                System.err.println("Failed to send ACK, retrying in " + backoffMillis + " ms...");
            } catch (InterruptedException e) {
                Thread.currentThread().interrupt();
                return;
            }

            retryCount++;
            try {
                Thread.sleep(backoffMillis);
            } catch (InterruptedException e) {
                Thread.currentThread().interrupt();
                return;
            }

            // Increase backoff time (exponential backoff)
            backoffMillis *= 2;
        }

        // If all retries fail, reject the message (move to DLQ or requeue)
        try {
            channel.basicNack(deliveryTag, false, true);  // Requeue the message
            System.err.println("Message requeued after failed retries.");
        } catch (IOException e) {
            System.err.println("Failed to NACK message.");
        }
    }
}