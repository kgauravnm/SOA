package com.example.customerservice.impl;

import java.util.HashMap;
import java.util.Map;

import javax.jws.WebService;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.example.customerservice.Customer;
import com.example.customerservice.CustomerService;
import com.example.customerservice.NoSuchCustomerException;

@WebService(endpointInterface = "com.example.customerservice.CustomerService")
public class CustomerServiceImpl implements CustomerService {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(CustomerServiceImpl.class); 
	
	private Map<String, Customer> customers;

	public CustomerServiceImpl() {
		customers = new HashMap<String, Customer>();

		Customer c = new Customer();
		c.setId("1");
		c.setName("Faculty of Mathematics, Physics and Informatics, Comenius University in Bratislava");
		c.setType("CORP");
		c.setLevel("GOLD");
		c.setAddress("Mlynská dolina", "84248", "Bratislava", "Slovak Republic");
		c.setPhone("+421-2-1111-2222");
		c.setMail("info@fmph.uniba.sk");
		c.setAccount("a-0001");

		customers.put(c.getId(), c);
	}

	@Override
	public Customer getInformation(String id) throws NoSuchCustomerException {
		LOGGER.info("getInformation called for a customer with id = {}", id);
		Customer c = customers.get(id);

		if (c == null) {
			throw new NoSuchCustomerException(id);
		} else {
			return c;
		}
	}
}
