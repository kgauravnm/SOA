package com.example.widgetservice.impl;

import javax.jws.WebService;

import com.example.widgetservice.WidgetService;

@WebService(endpointInterface = "com.example.widgetservice.WidgetService")
public class WidgetServiceImpl implements WidgetService
{
	@Override
	public boolean checkInventory(String productId, int pieces)
	{
		System.out.println("Checking inventory for product " + productId + ", " + pieces + " piece(s).");
		return pieces < 10;
	}
}

