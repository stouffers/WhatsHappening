<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<s:head/>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>Registration</title>
</head>
<body>
	<s:if test="%{#parameters.usertaken!=null}">
		<p class="error">Sorry, username ${param.usertaken} is already taken
	</s:if>
	<s:if test="%{#parameters.missing!=null}">
		<p class="error">Please fill out all entries</p>
	</s:if>
	<s:if test="%{#parameters.mismatch!=null}">
		<p class="error">Passwords did not match</p>
	</s:if>
	
	<s:form action="createuserAction" method="post">
		<s:textfield name="username" label="Username"/>
		<s:password name="password" label="Password"/>
		<s:password name="passConfirmation" label="Confirm Password"/>
		<s:textfield name="email" label="Email"/>
		<s:textfield name="fullName" label="Name"/>
		<s:submit value="Register"/>
	</s:form>
</body>
</html>