package com.example.workerservice;

import javax.jws.WebService;

@WebService
public interface WorkerService
{
	boolean checkInventory(String productId, int pieces);
}
