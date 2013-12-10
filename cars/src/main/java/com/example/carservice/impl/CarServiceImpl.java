package com.example.carservice.impl;

import java.util.HashMap;
import java.util.Map;

import javax.jws.WebService;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.example.carservice.Car;
import com.example.carservice.CarService;
import com.example.carservice.Manufacturer;
import com.example.carservice.NoSuchCarException;

@WebService(endpointInterface = "com.example.carservice.CarService")
public class CarServiceImpl implements CarService {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(CarServiceImpl.class); 
	
	private Map<String, Car> cars;

	public CarServiceImpl() {
		cars = new HashMap<String, Car>();

		Car c = new Car();
		c.setId("1");
		c.setModel("Corsa");
		c.setEngine("1.2");
		c.setManufacturer(new Manufacturer());
		c.getManufacturer().setCity("Heinburg");
		c.getManufacturer().setCountry("Germany");
		c.getManufacturer().setName("Opel");

		cars.put(c.getId(), c);
	}

	@Override
	public Car getInformation(String id) throws NoSuchCarException {
		LOGGER.info("getInformation called for a car with id = {}", id);
		Car c = cars.get(id);

		if (c == null) {
			throw new NoSuchCarException(id);
		} else {
			return c;
		}
	}
}
