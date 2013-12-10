package com.example.widgetservice.client;

import org.springframework.context.support.ClassPathXmlApplicationContext;

import com.example.widgetservice.WidgetService;

public final class Client
{
	public static void main(String args[]) throws Exception
	{
		ClassPathXmlApplicationContext context = new ClassPathXmlApplicationContext("client-context.xml");

		WidgetService client = context.getBean("client", WidgetService.class);

		System.out.println("Trying to check 5 pieces of a product p-0001...");
		System.out.println("- response: " + client.checkInventory("p-0001", 5));

		context.close();
		System.exit(0);
	}
}
