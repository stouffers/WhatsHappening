<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<s:head/>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>What's Happening?</title>
</head>
<body>
	<h2>Enter in your zip code to find out what's happening!</h2>
	<s:form action="event_query" method="get">
		<s:textfield name="zip" label="Zip Code"/><br/>
		<s:select name="distance" label="Farthest Distance"
			list="{1,2,5,10,25,50,100}"
			/>
		<s:submit value="Find out"/>
	</s:form>
	<h2>or log in to post a new event.</h2>
	<s:form action="login.jsp">
		<input type="submit" value="log in"/>
	</s:form>
	<a href=register.jsp>Create a new account</a>
</body>
</html>