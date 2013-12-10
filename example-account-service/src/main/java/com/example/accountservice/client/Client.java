package com.example.accountservice.client;

import java.math.BigDecimal;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.support.ClassPathXmlApplicationContext;

import com.example.accountservice.AccountService;

public final class Client {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(Client.class);

    public static void main(String args[]) {
    	
        ClassPathXmlApplicationContext context 
            = new ClassPathXmlApplicationContext("client-context.xml");
        AccountService accountService = (AccountService)context.getBean("accountService");
        
        LOGGER.info("Test1 (enough money): result = {}", accountService.checkCredit("a-0001", new BigDecimal(100)));
        LOGGER.info("Test2 (not enough money): result = {}", accountService.checkCredit("a-0001", new BigDecimal(1000)));
        LOGGER.info("Test3 (unknown account): result = {}", accountService.checkCredit("a-9999", new BigDecimal(1)));
        
        context.close();
        System.exit(0);
    }
}
