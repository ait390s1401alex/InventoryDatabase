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
    <meta http-equiv="content-type" content="text/html; charset=UTF-8">
    <link type="text/css" rel="stylesheet" href="/stylesheets/main.css" />
    <title>Economy Party Supplies - Inventory Management</title>
  </head>

  <body>
    <h1>Economy Party Supplies</h1>
    
  	<a href="/index.jsp">home</a>
  	
  	<hr/>
  	<h1>Inventory Management</h1>
  	
  	<p>Select a report to process.</p>
  	<form action="generateReport" method="port">
  	<select name="reports">
	  <option value="">Out of Stock List</option>
	  <option value="">TBD</option>
	  <option value="">TBD</option>
	  <option value="">TBD</option>
	</select>
	<input type="submit" name="Select"></input>
	</form>
	
	<p><a href="inventory.jsp">Inventory Management</a>
  	
  	<hr/>
    <h1>Costume Rental Tracking</h1>
	
	<p><a href="rental.jsp">Rental tracking</a></p>
	
  </body>
</html>
