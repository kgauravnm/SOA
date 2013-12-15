package com.example.orchservice;

import javax.jws.WebService;

import org.springframework.context.support.ClassPathXmlApplicationContext;

@WebService
public interface OrchService {
	boolean canRepair(String carId, String boxId, String workerId, String componentId);
}
