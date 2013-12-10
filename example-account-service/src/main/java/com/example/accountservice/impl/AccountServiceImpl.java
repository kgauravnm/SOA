package com.example.accountservice.impl;

import java.math.BigDecimal;
import java.util.HashMap;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.example.accountservice.AccountService;

public class AccountServiceImpl implements AccountService {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(AccountService.class);

	Map<String, BigDecimal> accounts;

	public AccountServiceImpl() {
		accounts = new HashMap<String, BigDecimal>();
		accounts.put("a-0001", new BigDecimal(100));
		accounts.put("a-0002", new BigDecimal(200));
		accounts.put("a-0003", new BigDecimal(300));
	}

	@Override
	public boolean checkCredit(String account, BigDecimal amount) {
		BigDecimal amountAvailable = accounts.get(account);
		boolean result = amountAvailable != null && amountAvailable.compareTo(amount) >= 0;

		LOGGER.info("Checking credit for account {}, amount = {}:", account, amount);
		LOGGER.info(" - available = {}, answer = {}", amountAvailable, result);

		return result;
	}

}
