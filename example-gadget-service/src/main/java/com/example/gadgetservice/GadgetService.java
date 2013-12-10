package com.example.gadgetservice;

import javax.jws.WebService;

@WebService
public interface GadgetService
{
	boolean checkInventory(String productId, int pieces);
}
