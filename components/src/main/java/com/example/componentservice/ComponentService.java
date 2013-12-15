package com.example.componentservice;

import javax.jws.WebService;

@WebService
public interface ComponentService
{
	boolean checkInventory(String productId, int pieces);
	
	void addComponent(String componentId, int pieces);
	
	void registerComponent (String componentId, Component component);

	Component getComponent (String componentId);
}
