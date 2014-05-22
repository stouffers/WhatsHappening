package com.whatshappening.struts.action;

import java.sql.SQLException;

import com.opensymphony.xwork2.Action;
import com.whatshappening.dao.UserDao;
import com.whatshappening.datamodels.User;

public class CreateUser implements Action {
	private UserDao dao;
	
	private static final String MISSING = "missing";
	private static final String MISMATCH = "mismatch";
	private static final String USERTAKEN = "usertaken";
	
	private String username;
	private String password;
	private String passConfirmation;
	private String fullName;
	private String email;

	public CreateUser(){
		dao = new UserDao();
	}
	
	@Override
	public String execute() throws Exception {
		// Verify inputs and attempt to insert a new user
		if( username.isEmpty() ||
			password.isEmpty() ||
			passConfirmation.isEmpty() ||
			email.isEmpty() )
			return MISSING;
		
		if(!password.equals(passConfirmation))
			return MISMATCH;
		
		try{
			if(dao.userExists(username))
				return USERTAKEN;
			
			User newUser = new User(username, password, fullName, email);
			
			if(dao.insertUser(newUser)<1)	// i.e. no rows were modified
				return ERROR;
			
		}catch(SQLException e){
			e.printStackTrace();
			return ERROR;
		}
		return SUCCESS;
	}

	public String getUsername() {
		return username;
	}

	public void setUsername(String username) {
		this.username = username;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public String getPassConfirmation() {
		return passConfirmation;
	}

	public void setPassConfirmation(String passConfirmation) {
		this.passConfirmation = passConfirmation;
	}

	public String getFullName() {
		return fullName;
	}

	public void setFullName(String fullName) {
		this.fullName = fullName;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

}
