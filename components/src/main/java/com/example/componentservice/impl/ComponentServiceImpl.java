package com.example.componentservice.impl;

import javax.jws.WebService;

import com.example.componentservice.ComponentService;

@WebService(endpointInterface = "com.example.componentservice.ComponentService")
public class ComponentServiceImpl implements ComponentService
{
	@Override
	public boolean checkInventory(String productId, int pieces)
	{
		System.out.println("Checking inventory for product " + productId + ", " + pieces + " piece(s).");
		return pieces < 10;
	}
}

