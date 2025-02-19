import com.rabbitmq.client.*;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.TimeoutException;

public class RabbitMqConsumer {

    private static final String QUEUE_NAME = "my_queue";
    private static final String DLX_NAME = "dlx_exchange";
    private static final String DLQ_NAME = "dlx_queue";
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

            // Declare DLX (Dead Letter Exchange)
            channel.exchangeDeclare(DLX_NAME, BuiltinExchangeType.DIRECT, true);

            // Declare DLQ (Dead Letter Queue)
            channel.queueDeclare(DLQ_NAME, true, false, false, null);
            channel.queueBind(DLQ_NAME, DLX_NAME, "dlx_routing_key");

            // Declare main queue with DLX settings
            Map<String, Object> args = new HashMap<>();
            args.put("x-dead-letter-exchange", DLX_NAME);
            args.put("x-dead-letter-routing-key", "dlx_routing_key");

            channel.queueDeclare(QUEUE_NAME, true, false, false, args);

            System.out.println("Waiting for messages...");

            DeliverCallback deliverCallback = (consumerTag, delivery) -> {
                long deliveryTag = delivery.getEnvelope().getDeliveryTag();
                String message = new String(delivery.getBody(), StandardCharsets.UTF_8);
                System.out.println("Received message: " + message);

                // Process message and send ACK with retry
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

        // If all retries fail, move the message to the DLQ
        try {
            channel.basicNack(deliveryTag, false, false); // Move to DLQ
            System.err.println("Message moved to Dead Letter Queue after failed retries.");
        } catch (IOException e) {
            System.err.println("Failed to NACK message.");
        }
    }
}