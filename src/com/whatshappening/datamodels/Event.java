package com.whatshappening.datamodels;

import org.joda.time.DateTime;

public class Event {
	private int eid;
	private User creator;
	private String name;
	private String description;
	private String address;
	private DateTime time;
	private float lat;
	private float lon;

	// For querying
	public Event(int eid, User creator, String name, String description,
			String address, DateTime time, float lat, float lon) {
		this.eid = eid;
		this.creator = creator;
		this.name = name;
		this.description = description;
		this.address = address;
		this.time = time;
		this.lat = lat;
		this.lon = lon;
	}

	// For insertion / coordinate entry
	public Event(User creator, String name, String description,
			String address, DateTime time, float lat, float lon) {
		this.eid = -1;
		this.creator = creator;
		this.name = name;
		this.description = description;
		this.address = address;
		this.time = time;
		this.lat = lat;
		this.lon = lon;
	}
	
	// For address entry
	public Event(User creator, String name, String description,
			String address, DateTime time) {
		this.eid = -1;
		this.creator = creator;
		this.name = name;
		this.description = description;
		this.address = address;
		this.time = time;
		this.lat = -1;
		this.lon = -1;
	}

	public int getEid() {
		return eid;
	}

	public User getCreator() {
		return creator;
	}

	public String getName() {
		return name;
	}

	public String getDescription() {
		return description;
	}

	public String getAddress() {
		return address;
	}

	public DateTime getTime() {
		return time;
	}

	public float getLat() {
		return lat;
	}

	public float getLon() {
		return lon;
	}

}
