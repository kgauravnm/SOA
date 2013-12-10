package com.example.boxservice.impl;

import java.math.BigDecimal;
import java.util.HashMap;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.example.boxservice.BoxService;

public class BoxServiceImpl implements BoxService {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(BoxService.class);

	Map<String, BigDecimal> boxs;

	public BoxServiceImpl() {
		boxs = new HashMap<String, BigDecimal>();
		boxs.put("a-0001", new BigDecimal(100));
		boxs.put("a-0002", new BigDecimal(200));
		boxs.put("a-0003", new BigDecimal(300));
	}

	@Override
	public boolean checkCredit(String box, BigDecimal amount) {
		BigDecimal amountAvailable = boxs.get(box);
		boolean result = amountAvailable != null && amountAvailable.compareTo(amount) >= 0;

		LOGGER.info("Checking credit for box {}, amount = {}:", box, amount);
		LOGGER.info(" - available = {}, answer = {}", amountAvailable, result);

		return result;
	}

}
