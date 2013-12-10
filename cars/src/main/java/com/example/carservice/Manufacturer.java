package com.example.carservice;

public class Manufacturer {
	private String name, city, country;

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getCity() {
		return city;
	}

	public void setCity(String city) {
		this.city = city;
	}

	public String getCountry() {
		return country;
	}

	public void setCountry(String country) {
		this.country = country;
	}

	public String toString() {
		return "Manufacturer:[name=" + name + ", city=" + city
				+ ", country=" + country + "]";
	}
}
