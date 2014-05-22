package com.whatshappening.dbconn;

import java.io.IOException;
import java.io.InputStream;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Connection;
import java.util.Properties;

import javax.sql.DataSource;

import com.mysql.jdbc.jdbc2.optional.MysqlDataSource;


public class DBConnection {
	private static DataSource pool=null;

	public static synchronized Connection getConnection() throws SQLException{
		if(pool==null){	// Generates a new datasource if none exists yet
	        Properties props = new Properties();
	        MysqlDataSource mysqlDS = null;
	        try {	// load connection info into properties object
	        	InputStream is = DBConnection.class.getClassLoader().getResourceAsStream("db.properties"); //<<=====
	            props.load(is);
	        } catch (IOException e) {
	            e.printStackTrace();
	        }
            
            // generate datasource
            mysqlDS = new MysqlDataSource();
            mysqlDS.setURL(props.getProperty("MYSQL_DB_URL") + props.getProperty("MYSQL_DB_NAME"));
            mysqlDS.setUser(props.getProperty("MYSQL_DB_USERNAME"));
            mysqlDS.setPassword(props.getProperty("MYSQL_DB_PASSWORD"));
            pool = mysqlDS;
		}
        try {
			Connection conn = pool.getConnection();
			return conn;
		} catch (SQLException e) {
			throw new SQLException("Could not retrieve db connection: ", e);
		}
	}
	
	public static void close(ResultSet rs, Statement stmt, Connection conn){
	    try { if (rs != null) rs.close(); } 
	    catch (SQLException e) {e.printStackTrace();};
	    try { if (stmt != null) stmt.close(); } 
	    catch (SQLException e) {e.printStackTrace();};
	    try { if (conn != null) conn.close(); } 
	    catch (SQLException e) {e.printStackTrace();};
	}
}
