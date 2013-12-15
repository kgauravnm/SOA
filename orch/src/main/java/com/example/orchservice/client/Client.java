package com.example.orchservice.client;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.support.ClassPathXmlApplicationContext;

import com.example.orchservice.OrchService;

public final class Client {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(Client.class); 

	public static void main(String args[]) throws Exception {
		
		ClassPathXmlApplicationContext context = new ClassPathXmlApplicationContext("client-context.xml");

		OrchService client = context.getBean("client", OrchService.class);

		LOGGER.info("Can repair car 1 in box 2 by jakuub, replace wheel: " + client.canRepair("1", "box-2", "jakuub", "wheel"));
		LOGGER.info("Can repair car 1 in box 3 by jakuub, replace wheel: " + client.canRepair("1", "box-3", "jakuub", "wheel"));
		LOGGER.info("Can repair car 1 in box 2 by jakuub, replace engine: " + client.canRepair("1", "box-2", "jakuub", "engine"));
		LOGGER.info("Can repair car 1 in box 2 by jakuub, replace seet: " + client.canRepair("1", "box-2", "jakuub", "seet"));
		
		

		context.close();
		System.exit(0);
	}
}
