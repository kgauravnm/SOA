package com.example.customerservice.client;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.support.ClassPathXmlApplicationContext;

import com.example.customerservice.Customer;
import com.example.customerservice.CustomerService;

public final class Client {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(Client.class); 

	public static void main(String args[]) throws Exception {
		
		ClassPathXmlApplicationContext context = new ClassPathXmlApplicationContext("client-context.xml");

		CustomerService client = context.getBean("client", CustomerService.class);

		LOGGER.info("Trying to find a customer with an id of 1...");
		Customer response = client.getInformation("1");
		LOGGER.info("- response: {}", response);

		try {
			LOGGER.info("Trying to find a customer with a (non-existing) id of 9999...");
			Customer response2 = client.getInformation("9999");
			LOGGER.info("- response: {}", response2);
		} catch (Exception e) {
			LOGGER.info("- got an exception", e);
		}

		context.close();
		System.exit(0);
	}
}
