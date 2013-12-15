package com.example.componentservice;

public class Component {
	
	String id;
	
	String name;
	
	String type;
	
	public Component(String id, String name, String type) {
		super();
		this.id = id;
		this.name = name;
		this.type = type;
	}
	
	public Component() {
		super();
	}

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	public String toString(){
		return "Component[id: " + id + ", name: " + name + ", type: " + type + "]";
		
	}
}
