package com.example.carservice.client;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.support.ClassPathXmlApplicationContext;

import com.example.carservice.Car;
import com.example.carservice.CarService;
import com.example.carservice.Manufacturer;

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
		
		Car car = new Car();
		car.setId("2");
		car.setModel("Signum");
		car.setEngine("1.5");
		car.setManufacturer(new Manufacturer());
		car.getManufacturer().setCity("Heinburg");
		car.getManufacturer().setCountry("Germany");
		car.getManufacturer().setName("Opel");
		
		LOGGER.info("Trying to add a car with an id of 2...");
		client.addCar(car);
		LOGGER.info("Trying to find a added car with an id of 2...");
		response = client.getInformation("2");
		LOGGER.info("- response: {}", response);
		
		
		

		context.close();
		System.exit(0);
	}
}
