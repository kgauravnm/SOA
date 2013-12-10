package com.example.carservice;

import javax.jws.WebService;

@WebService
public interface CarService {
	Car getInformation(String id) throws NoSuchCarException;
}
