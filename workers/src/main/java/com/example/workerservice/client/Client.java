package com.example.workerservice.client;

import java.util.Date;

import org.springframework.context.support.ClassPathXmlApplicationContext;

import com.example.workerservice.WorkerService;

public final class Client
{
	public static void main(String args[]) throws Exception
	{
		ClassPathXmlApplicationContext context = new ClassPathXmlApplicationContext("client-context.xml");

		WorkerService client = context.getBean("client", WorkerService.class);

		System.out.println("Trying to check if jakuub is working...");
		System.out.println("- response: " + client.checkWorkingAt("jakuub", new Date(), new Date()));

		System.out.println("Trying to add Peter working...");
		client.setWorkingAt("Peter", new Date(), new Date());

		System.out.println("Trying to check if Peter is working...");
		System.out.println("- response: " + client.checkWorkingAt("Peter", new Date(), new Date()));

		System.out.println("Trying to remove Peter working...");
		client.removeWorkingAt("Peter", new Date(), new Date());

		System.out.println("Trying to check if Peter is working...");
		System.out.println("- response: " + client.checkWorkingAt("Peter", new Date(), new Date()));

		context.close();
		System.exit(0);
	}
}
