package com.example.gadgetservice.client;

import org.springframework.context.support.ClassPathXmlApplicationContext;

import com.example.gadgetservice.GadgetService;

public final class Client
{
	public static void main(String args[]) throws Exception
	{
		ClassPathXmlApplicationContext context = new ClassPathXmlApplicationContext("client-context.xml");

		GadgetService client = context.getBean("client", GadgetService.class);

		System.out.println("Trying to check 5 pieces of a product g-0001...");
		System.out.println("- response: " + client.checkInventory("g-0001", 5));

		context.close();
		System.exit(0);
	}
}
