package com.example.workerservice.impl;

import javax.jws.WebService;

import com.example.workerservice.WorkerService;

@WebService(endpointInterface = "com.example.workerservice.WorkerService")
public class WorkerServiceImpl implements WorkerService
{
	@Override
	public boolean checkInventory(String productId, int pieces)
	{
		return pieces < 10;
	}
}

