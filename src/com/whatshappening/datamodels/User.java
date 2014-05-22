package com.whatshappening.datamodels;

public class User {
	private int uid;
	private String username;
	private String password;
	private String fullname;
	private String email;
	
	public User(String username, String password, String fullname,
			String email) {
		this.uid=-1;
		this.username = username;
		this.password = password;
		this.fullname = fullname;
		this.email = email;
	}
	
	public User(int uid, String username, String password, String fullname,
			String email) {
		this.uid = uid;
		this.username = username;
		this.password = password;
		this.fullname = fullname;
		this.email = email;
	}
	
	public User(int uid, String username,String fullname,
			String email) {
		this.uid = uid;
		this.username = username;
		this.password = null;
		this.fullname = fullname;
		this.email = email;
	}

	public int getUid() {
		return uid;
	}

	public String getUsername() {
		return username;
	}

	public String getPassword() {
		return password;
	}

	public String getFullname() {
		return fullname;
	}

	public String getEmail() {
		return email;
	}
	
}
