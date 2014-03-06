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
<%@ page import="inventory.db.Product" %>
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
    
    <title>Economy Party Supplies - Admin - Products</title>
    
  </head>
  
  	

  <body>
  
  
  	<a href="admin.jsp">return to admin main</a>
  	<a href="/index.jsp">home</a>
  
  <%
    UserService userService = UserServiceFactory.getUserService();
    User user = userService.getCurrentUser();
    if (user != null) {
      	pageContext.setAttribute("user", user);
	%>
		<p>Hello, ${fn:escapeXml(user.nickname)}! (You can <a href="<%= userService.createLogoutURL(request.getRequestURI()) %>">sign out</a>.)</p>
	<%
	    } else {
	%>
		<p>Hello! <a href="<%= userService.createLoginURL(request.getRequestURI()) %>">Sign in</a></p>
	<%
	    }
	%>
  
  
	<%
		List<Entity> allProducts = Product.getFirstProducts(100);
		if (allProducts.isEmpty()) {
	%>
	<h1>No Products Entered</h1>
	<%
		}else{	
	%>
	<h1>All Products</h1>
	<table border="1">
		<tr>
			<td>Product</td>
			<td>Update</td>
			<td>Delete</td>
		</tr>
		<%
			for (Entity product : allProducts) {
					String productName = Product.getName(product);
					String id = Product.getStringID(product);
		%>

		<tr>
			<td><%=productName%></td>
			<td>
				<form action="updateProduct" method="post">
					<input type="hidden" name="id" value="<%=id%>" />
					<input type="text" name="recordTime" size="20" />
					<input type="submit" value="Update" />
				</form>
			</td>
			<td>
				<a href="deleteProduct?id=<%=id%>">delete</a>
			</td>

		</tr>

		<%
			}

		}
		%>

	</table>
	


	<hr />
    <form action="addProduct" method="post">
      <div><input type="text" name="productName" size="50" /></div>
      <div><input type="submit" value="Add Product" /></div>
    </form>

  </body>
</html>