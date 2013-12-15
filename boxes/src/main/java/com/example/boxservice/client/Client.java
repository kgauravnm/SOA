package com.example.boxservice.client;

import java.math.BigDecimal;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.support.ClassPathXmlApplicationContext;

import com.example.boxservice.BoxService;

public final class Client {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(Client.class);

    public static void main(String args[]) {
    	
        ClassPathXmlApplicationContext context 
            = new ClassPathXmlApplicationContext("client-context.xml");
        BoxService boxService = (BoxService)context.getBean("boxService");
        
        LOGGER.info("Test1 (box-1): result = {}", boxService.checkBoxFree("box-1"));
        LOGGER.info("Test2 (box-2): result = {}", boxService.checkBoxFree("box-2"));
        LOGGER.info("Test3 (unknown box): result = {}", boxService.checkBoxFree("box-9999"));
        
        context.close();
        System.exit(0);
    }
}
