package com.example.widgetservice;

import javax.jws.WebService;

@WebService
public interface WidgetService
{
	boolean checkInventory(String productId, int pieces);
}
