package com.example.componentservice;

import javax.jws.WebService;

@WebService
public interface ComponentService
{
	boolean checkInventory(String productId, int pieces);
}
