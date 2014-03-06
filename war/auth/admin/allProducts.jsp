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
			<td>Quantity</td>
			<td>Purchase Price</td>
			<td>Sales Price</td>
			<td>Min Quantity</td>
			<td>Max Quantity</td>
			<td>Deleted Product</td>
		</tr>
		<%
			for (Entity product : allProducts) {
					String productName = Product.getName(product);
					String quantity = Product.getQuantity(product);
					String purchasePrice = Product.getPurchasePrice(product);
					String salesPrice = Product.getSalesPrice(product);
					String minQuantity = Product.getMinQuantity(product);
					String maxQuantity = Product.getMaxQuantity(product);
					String id = Product.getStringID(product);
		%>

		<tr>
			<td><%=productName%></td>
			<td><%=quantity%></td>
			<td><%=purchasePrice%></td>
			<td><%=salesPrice%></td>
			<td><%=minQuantity%></td>
			<td><%=maxQuantity%></td>
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
    <table>
    	<tr>
    		<td>Product Name: </td><td><input type="text" name="productName" size="50" /></td>
    	</tr>
    	<tr>
	    		<td>Quantity: </td><td><input type="text" name="quantity" size="50" /></td>
    	</tr>
    	<tr>
	    		<td>Purchase Price: </td><td><input type="text" name="purchasePrice" size="50" /></td>
    	</tr>
    	<tr>
	    		<td>Sales Price: </td><td><input type="text" name="salesPrice" size="50" /></td>
    	</tr>
    	<tr>
	    		<td>Min Quantity Defined: </td><td><input type="text" name="minQuantity" size="50" /></td>
    	</tr>
    	<tr>
	    		<td>Max Quantity Defined: </td><td><input type="text" name="maxQuantity" size="50" /></td>
    	</tr>
     </table>
      <div><input type="submit" value="Add Product" /></div>
    </form>

  </body>
</html>