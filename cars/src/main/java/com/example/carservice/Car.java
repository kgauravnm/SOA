package com.example.carservice;

/*
 * Car transfer object - carries basic data about a car.
 */
public class Car {
	private String id;			// internal identification number of the car
	private String model;		// e.g. Faculty of Mathematics, Physics and Informatics, Comenius University in Bratislava
	private Manufacturer manufacturer;	// contact address 
	private String engine;		// contact phone

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}


	public String getModel() {
		return model;
	}


	public void setModel(String model) {
		this.model = model;
	}


	public Manufacturer getManufacturer() {
		return manufacturer;
	}


	public void setManufacturer(Manufacturer manufacturer) {
		this.manufacturer = manufacturer;
	}


	public String getEngine() {
		return engine;
	}


	public void setEngine(String engine) {
		this.engine = engine;
	}

	public String toString(){
		return "Car:[id: " + id + ", model: " + model + ", manufacturer: " + manufacturer.toString() + ", engine: " + engine + "]"; 
	}
	
}
