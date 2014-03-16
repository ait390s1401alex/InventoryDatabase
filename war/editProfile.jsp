<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.google.appengine.api.users.User" %>
<%@ page import="com.google.appengine.api.users.UserService" %>
<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>
<%@ page import="com.google.appengine.api.datastore.DatastoreServiceFactory" %>
<%@ page import="com.google.appengine.api.datastore.DatastoreService" %>
<%@ page import="com.google.appengine.api.datastore.Query" %>
<%@ page import="com.google.appengine.api.datastore.Entity" %>
<%@ page import="com.google.appengine.api.datastore.FetchOptions" %>
<%@ page import="com.google.appengine.api.datastore.Key" %>
<%@ page import="com.google.appengine.api.datastore.KeyFactory" %>
<%@ page import="inventory.db.InvUser" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>



<!--  
   Copyright 2014 - 
   Licensed under the Academic Free License version 3.0
   http://opensource.org/licenses/AFL-3.0

   Authors: Alex Verkhovtsev 
   
   Version 0.1 - Spring 2014
-->



<html>
  
  <head>
    <link type="text/css" rel="stylesheet" href="/stylesheets/main.css" />
    
    <title>Economy Part Supply</title>
    
  </head>

  	<a href="index.jsp">home</a>

<body background="/stylesheets/medals.png">
<div class="background" align="center">
	 
  
  <%
    UserService userService = UserServiceFactory.getUserService();
    User user = userService.getCurrentUser();
    if (user != null) {
      	pageContext.setAttribute("user", user);
	%>
		<p>Hello, ${fn:escapeXml(user.nickname)}! (You can <a href="/logout">sign out</a>.)</p>
	<%
	    } else {
	%>
		<p>Hello! <a href="<%= userService.createLoginURL(request.getRequestURI()) %>">Sign in</a></p>
	<%
	    }
       
    Entity invUser = InvUser.getInvUserWithLoginID(user.getNickname());
    
    if(invUser == null){
    	%>
    	
    	<h2>Welcome <%=user.getNickname() %>! Please enter some basic information.</h2>
		<form action="addUser" method="post">
			<table>
				<tr>
					<td>First Name: </td><td><input type="text" name="firstName" length="30"  /></td>
				</tr>
				<tr>
					<td>Last Name: </td><td><input type="text" name="lastName" length="30" /></td>
				</tr>
				
			</table>
			<input type="hidden" name="loginID" value="<%=user.getNickname()%>" />
			<input type="submit" value="Update" />
		</form>
    	
    	<%
    }else{
    	
    	
    	%>
		<h2>Welcome <%=InvUser.getFirstName(invUser) %>! Edit your profile below!</h2>
		<form action="updateUser" method="post">
			<table>
				<tr>
					<td>First Name: </td><td><input type="text" name="firstName" length="30" value="<%=InvUser.getFirstName(invUser) %>" /></td>
				</tr>
				<tr>
					<td>Last Name: </td><td><input type="text" name="lastName" length="30" value="<%=InvUser.getLastName(invUser) %>" /></td>
				</tr>
				
				
			</table>
			<input type="hidden" name="loginID" value="<%=user.getNickname()%>" />
			<input type="hidden" name="invUserID" value="<%=InvUser.getStringID(invUser)%>" />
			<input type="submit" value="update" />
		</form>

	<%
    	
    	
    	
    
    
    }
    
	%>
  
	</div>
  </body>
 
</html>