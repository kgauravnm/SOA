package com.example.componentservice.client;

import org.springframework.context.support.ClassPathXmlApplicationContext;

import com.example.componentservice.ComponentService;

public final class Client
{
	public static void main(String args[]) throws Exception
	{
		ClassPathXmlApplicationContext context = new ClassPathXmlApplicationContext("client-context.xml");

		ComponentService client = context.getBean("client", ComponentService.class);

		System.out.println("Trying to check 5 pieces of a product p-0001...");
		System.out.println("- response: " + client.checkInventory("p-0001", 5));

		context.close();
		System.exit(0);
	}
}
