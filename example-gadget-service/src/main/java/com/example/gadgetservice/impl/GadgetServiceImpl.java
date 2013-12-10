package com.example.gadgetservice.impl;

import javax.jws.WebService;

import com.example.gadgetservice.GadgetService;

@WebService(endpointInterface = "com.example.gadgetservice.GadgetService")
public class GadgetServiceImpl implements GadgetService
{
	@Override
	public boolean checkInventory(String productId, int pieces)
	{
		return pieces < 10;
	}
}

