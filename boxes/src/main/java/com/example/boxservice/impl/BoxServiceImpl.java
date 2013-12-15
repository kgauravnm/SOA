package com.example.boxservice.impl;

import java.math.BigDecimal;
import java.util.HashMap;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.example.boxservice.BoxService;

public class BoxServiceImpl implements BoxService {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(BoxService.class);

	Map<String, Boolean> boxes;

	public BoxServiceImpl() {
		boxes = new HashMap<String, Boolean>();
		boxes.put("box-2", new Boolean(false));
		boxes.put("box-2", new Boolean(true));
		boxes.put("box-3", new Boolean(false));
	}

	@Override
	public boolean checkBoxFree(String box) {
		LOGGER.info("Checking if box {} is free:", box);
		
		Boolean free = boxes.get(box);
		boolean eviable = free != null && free.booleanValue();
		
		LOGGER.info(" - available = {}", eviable);

		return eviable;
	}

}
