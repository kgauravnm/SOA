package com.example.widgetservice.server;

import org.springframework.context.support.ClassPathXmlApplicationContext;

public class Server
{
	public static void main(String args[]) throws Exception
	{
		ClassPathXmlApplicationContext context = new ClassPathXmlApplicationContext("server-context.xml");
		System.in.read();
		context.close();
	}
}
