package com.example.boxservice.server;

import java.io.IOException;

import org.springframework.context.support.ClassPathXmlApplicationContext;

public class Server {
    
    public static void main(String args[]) throws IOException {
    	ClassPathXmlApplicationContext context = new ClassPathXmlApplicationContext("server-context.xml");
        System.in.read();
        context.close();
    }
}
