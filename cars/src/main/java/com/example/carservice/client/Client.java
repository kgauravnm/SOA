package com.example.carservice.client;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.support.ClassPathXmlApplicationContext;

import com.example.carservice.Car;
import com.example.carservice.CarService;

public final class Client {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(Client.class); 

	public static void main(String args[]) throws Exception {
		
		ClassPathXmlApplicationContext context = new ClassPathXmlApplicationContext("client-context.xml");

		CarService client = context.getBean("client", CarService.class);

		LOGGER.info("Trying to find a car with an id of 1...");
		Car response = client.getInformation("1");
		LOGGER.info("- response: {}", response);

		try {
			LOGGER.info("Trying to find a car with a (non-existing) id of 9999...");
			Car response2 = client.getInformation("9999");
			LOGGER.info("- response: {}", response2);
		} catch (Exception e) {
			LOGGER.info("- got an exception", e);
		}

		context.close();
		System.exit(0);
	}
}
