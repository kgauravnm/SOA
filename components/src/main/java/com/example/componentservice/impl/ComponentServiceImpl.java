package com.example.componentservice.impl;

import java.util.HashMap;
import java.util.Map;

import javax.jws.WebService;

import com.example.componentservice.Component;
import com.example.componentservice.ComponentService;

@WebService(endpointInterface = "com.example.componentservice.ComponentService")
public class ComponentServiceImpl implements ComponentService
{
	Map<String, Integer> componentInventory;
	
	Map<String, Component> components;
	
	public ComponentServiceImpl() {
		componentInventory = new HashMap<String, Integer>();
		components = new HashMap<String, Component>();
		
		componentInventory.put("wheel", 3);
		componentInventory.put("seet", 4);
		
		components.put("wheel", new Component("wheel", "Wheel", "podvozok"));
		components.put("seet", new Component("seet", "Seet", "interier"));
	}
	
	@Override
	public boolean checkInventory(String componentId, int pieces)
	{
		System.out.println("Checking inventory for product " + componentId + ", " + pieces + " piece(s).");
		Integer have = componentInventory.get(componentId);

		return have != null && have.intValue() > pieces;
	}

	@Override
	public void addComponent(String componentId, int pieces) {
		Integer have = componentInventory.get(componentId);
		
		if (have == null)
			have = new Integer(pieces);
		else 
			have = new Integer(have.intValue() + pieces);
		
		componentInventory.put(componentId, have);
		
	}

	@Override
	public void registerComponent(String componentId, Component component) {
		components.put(componentId, component);
		
	}

	@Override
	public Component getComponent(String componentId) {
		return components.get(componentId);
		
	}
}

