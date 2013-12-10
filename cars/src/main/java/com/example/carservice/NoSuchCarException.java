package com.example.carservice;

public class NoSuchCarException extends Exception {
	
	private static final long serialVersionUID = 1L;

	private String id;

	public NoSuchCarException(String id) {
		super("Cannot find a car with id = " + id);
		this.id = id;
	}

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}
}
