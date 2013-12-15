package com.example.componentservice.client;

import org.springframework.context.support.ClassPathXmlApplicationContext;

import com.example.componentservice.Component;
import com.example.componentservice.ComponentService;

public final class Client
{
	public static void main(String args[]) throws Exception
	{
		ClassPathXmlApplicationContext context = new ClassPathXmlApplicationContext("client-context.xml");

		ComponentService client = context.getBean("client", ComponentService.class);

		System.out.println("Trying to check 5 pieces of a component wheel...");
		System.out.println("- response: " + client.checkInventory("wheel", 5));

		System.out.println("Trying to check 2 pieces of a component wheel...");
		System.out.println("- response: " + client.checkInventory("wheel", 2));

		System.out.println("Adding new wheels...");
		client.addComponent("wheel", 10);

		System.out.println("Trying to check 5 pieces of a component wheel...");
		System.out.println("- response: " + client.checkInventory("wheel", 5));

		System.out.println("Trying to check 5 pieces of a component wheel...");
		System.out.println("- response: " + client.checkInventory("wheel", 5));

		System.out.println("Adding new component engine...");
		client.registerComponent("engine", new Component("engine", "Engine 1.5", "pohon"));
		
		
		System.out.println("Geting component engine...");
		System.out.println("- response: " + client.getComponent("engine"));
		
		

		context.close();
		System.exit(0);
	}
}
