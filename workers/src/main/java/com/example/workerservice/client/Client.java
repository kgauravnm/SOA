package com.example.workerservice.client;

import org.springframework.context.support.ClassPathXmlApplicationContext;

import com.example.workerservice.WorkerService;

public final class Client
{
	public static void main(String args[]) throws Exception
	{
		ClassPathXmlApplicationContext context = new ClassPathXmlApplicationContext("client-context.xml");

		WorkerService client = context.getBean("client", WorkerService.class);

		System.out.println("Trying to check 5 pieces of a product g-0001...");
		System.out.println("- response: " + client.checkInventory("g-0001", 5));

		context.close();
		System.exit(0);
	}
}
