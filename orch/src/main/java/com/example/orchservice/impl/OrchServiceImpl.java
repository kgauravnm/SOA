package com.example.orchservice.impl;

import java.util.Date;

import javax.jws.WebService;

import org.springframework.context.support.ClassPathXmlApplicationContext;

import com.example.boxservice.BoxService;
import com.example.carservice.Car;
import com.example.carservice.CarService;
import com.example.componentservice.ComponentService;
import com.example.orchservice.OrchService;
import com.example.workerservice.WorkerService;

@WebService(endpointInterface = "com.example.orchservice.OrchService")
public class OrchServiceImpl implements OrchService {

	CarService cars;

	ComponentService components;

	BoxService boxes;

	WorkerService workers;

	public OrchServiceImpl() {
		ClassPathXmlApplicationContext context = new ClassPathXmlApplicationContext(
				"impl-context.xml");

		cars = context.getBean("cars", CarService.class);

		components = context.getBean("components", ComponentService.class);

		boxes = context.getBean("boxes", BoxService.class);

		workers = context.getBean("workers", WorkerService.class);
		
//		context.close();

	}

	@Override
	public boolean canRepair(String carId, String boxId, String workerId,
			String componentId) {
		boolean isCar = false;
		try {
			Car car = cars.getInformation(carId);
			isCar = car != null;
		} catch (Exception e) {
		}

		Boolean boxFree = boxes.checkBoxFree(boxId);
		boolean boxAviable = boxFree != null && boxFree.booleanValue();

		Boolean workerNotFree = workers.checkWorkingAt(workerId, null,
				null);
		boolean workerFree = workerNotFree == null
				|| !workerNotFree.booleanValue();
//		boolean workerFree = true;

		boolean haveComponent = components.checkInventory(componentId, 1);
		return haveComponent && workerFree && boxAviable && isCar;
	}

}
