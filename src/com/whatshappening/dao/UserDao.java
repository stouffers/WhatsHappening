package com.whatshappening.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;


import com.whatshappening.datamodels.User;
import com.whatshappening.dbconn.DBConnection;

// Manages lookups and modifications for the users db table
public class UserDao {
	
	private User getUserFromRS(ResultSet rs) throws SQLException{
		User user = new User(
					rs.getInt("uid"),
					rs.getString("username"),
					rs.getString("password"),
					rs.getString("fullname"),
					rs.getString("email")
				);
		return user;
	}
	
	public User lookupUser(int uid) throws SQLException{
		final String query = "SELECT uid,username,password,fullname,email FROM users WHERE uid = ? ";
		Connection conn = null;
		PreparedStatement statement = null;
		ResultSet results = null;
		
		User user = null;
		
		try {
			conn = DBConnection.getConnection();
			statement = conn.prepareStatement(query);
			statement.setInt(1, uid);
			
			results = statement.executeQuery();
			if(!results.next()) return null;
			user = getUserFromRS(results);
		}catch (SQLException e) {
			throw e;
		}finally{
			DBConnection.close(results, statement, conn);
		}
		
		return user;
	}
	
	public User lookupUser(String username) throws SQLException{
		final String query = "SELECT uid,username,password,fullname,email FROM users WHERE username = ? ";
		Connection conn = null;
		PreparedStatement statement = null;
		ResultSet results = null;
		
		User user = null;
		
		try {
			conn = DBConnection.getConnection();
			statement = conn.prepareStatement(query);
			statement.setString(1, username);
			
			results = statement.executeQuery();
			if(!results.next()) return null;
			user = getUserFromRS(results);
		}catch (SQLException e) {
			throw e;
		}finally{
			DBConnection.close(results, statement, conn);
		}
		
		return user;
	}
	
	public boolean userExists(String username) throws SQLException{
		return lookupUser(username)!=null;
	}
	
	public int insertUser(User user) throws SQLException{
		final String query = "INSERT INTO users(username,password,fullname,email) VALUES ( ?, ?, ?, ? )";
		Connection conn = null;
		PreparedStatement statement = null;
		int returnCode = -1;
		
		try {
			conn = DBConnection.getConnection();
			statement = conn.prepareStatement(query);
			statement.setString(1, user.getUsername());
			statement.setString(2, user.getPassword());
			statement.setString(3, user.getFullname());
			statement.setString(4, user.getEmail());
			
			returnCode = statement.executeUpdate();
		}catch (SQLException e) {
			throw e;
		}finally{
			DBConnection.close(null, statement, conn);
		}
		
		return returnCode;
	}

}
