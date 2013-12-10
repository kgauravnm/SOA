package com.example.customerservice;

import javax.jws.WebService;

@WebService
public interface CustomerService {
	Customer getInformation(String id) throws NoSuchCustomerException;
}
