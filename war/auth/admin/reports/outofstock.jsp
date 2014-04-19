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
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

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
    <title>Economy Party Supplies - Inventory Management - Report</title>
    
    <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js"></script>
    <script type="text/javascript" charset="utf-8" src="/DataTables/media/js/jquery.js"></script>
	<script type="text/javascript" charset="utf-8" src="/DataTables/media/js/jquery.dataTables.js"></script>
    
    <script>
	    $(document).ready(function() {
        	$('#maintable').dataTable();
    		} );
    </script>
    

  </head>

  <body>
  <h1>Out of Stock</h1>
  
  <%
  		List<Entity> products = Product.getOutOfStock(1000);
  %>
  
  <table id="maintable">
  	<thead>
  		<tr>
  			<th>Product Name</th>
  			<th>Quantity</th>
  			<th>Min Quantity</th>
  			<th>Max Quantity</th>
 		</tr>
 	</thead>
 	<tbody>
  <%
  		for(Entity product: products){
  			String productName = Product.getName(product);
			String quantity = Product.getQuantity(product);
			String purchasePrice = Product.getPurchasePrice(product);
			String salesPrice = Product.getSalesPrice(product);
			String minQuantity = Product.getMinQuantity(product);
			String maxQuantity = Product.getMaxQuantity(product);
  		
  %>
  	
  		<tr>
  			<td><%=productName %></td>
  			<td><%=quantity %></td>
  			<td><%=minQuantity %></td>
  			<td><%=maxQuantity %></td>
  		</tr>
  <%
  		}
  %>
  </tbody>
  </table>
  
 
  
	  
  </body>
</html>
