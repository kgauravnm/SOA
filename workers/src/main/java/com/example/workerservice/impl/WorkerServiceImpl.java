package com.example.workerservice.impl;

import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import javax.jws.WebService;

import com.example.workerservice.WorkerService;

@WebService(endpointInterface = "com.example.workerservice.WorkerService")
public class WorkerServiceImpl implements WorkerService
{
	Map<String, Boolean> working;
	
	public WorkerServiceImpl() {
		// TODO Auto-generated constructor stub
		working = new HashMap<String, Boolean>();
	}
	
	@Override
	public boolean checkWorkingAt(String name, Date from, Date to)
	{
		Boolean work = working.get(name);
		return work != null && work.booleanValue();
	}

	@Override
	public void setWorkingAt(String name, Date from, Date to) {
		working.put(name, true);
	}

	@Override
	public void removeWorkingAt(String name, Date from, Date to) {
		working.put(name, false);
	}
}

