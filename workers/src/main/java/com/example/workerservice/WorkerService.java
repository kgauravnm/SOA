package com.example.workerservice;

import java.util.Date;

import javax.jws.WebService;

@WebService
public interface WorkerService
{
	boolean checkWorkingAt(String name, Date from, Date to);
	
	void setWorkingAt(String name, Date from, Date to);

	void removeWorkingAt(String name, Date from, Date to);
}
