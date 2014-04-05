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
<%@ page import="inventory.db.InvUser" %>
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
    <link type="text/css" rel="stylesheet" href="/stylesheets/main.css" />
    
    <title>Economy Party Supplies - Inventory</title>
    
    
    
        <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js"></script>
        <script type="text/javascript" charset="utf-8" src="/DataTables/media/js/jquery.js"></script>
		<script type="text/javascript" charset="utf-8" src="/DataTables/media/js/jquery.dataTables.js"></script>
    
    <script>
	

    function editButton(ID) {
    	$("#productIDUpdate").val(ID);
    	document.getElementById("updatepopup").style.display = "";
    }
    
    function cancelButton(ID) {
    	document.getElementById("updatepopup").style.display = "none";
    }
    
    
    function saveButton() {
    	var intRegex = /^\d+$/;
    	document.getElementById("updatepopup").style.display = "none";
    	if(intRegex.test($("#newQuant"))) {
    		alert('Invalid entry. Please only enter a non negative integer.');
    	}else{
    		document.forms["finalSubmit"].submit();
    	}
    	
    }
    
    $(document).ready(function() {
        $('#maintable').dataTable();
    } );
    
    </script>
    
  </head>
  
  	

  <body>
  
  
  	<a href="user.jsp">return to user main</a>
  	<a href="/index.jsp">home</a>
  
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
		<c:redirect url="/index.jsp" />
	<%
	    }
	%>
  
  
	<%
		List<Entity> allProducts = Product.getFirstProducts(100);
		if (allProducts.isEmpty()) {
	%>
	<h1>No Products in DB</h1>
	<%
		}else{	
			
			String userID = InvUser.getStringID(InvUser.getInvUserWithLoginID(user.getNickname()));
	%>
	<h1>All Products</h1>
	
	<table id="maintable" border="1">
	<thead>
		<tr>
			<th>Name</th>
			<th>Min Quantity</th>
			<th>Max Quantity</th>
			<th>Current Quantity</th>
			<th>Edit</th>
		</tr>
	</thead>
	<tbody>
		<%
		for (Entity product : allProducts) {
			String name = Product.getName(product);
			String minQuant = Product.getMinQuantity(product);
			String maxQuant = Product.getMaxQuantity(product);
			String quantity = Product.getQuantity(product);
			String id = Product.getStringID(product);
			
				
				%>
				

				<tr id="view<%=id%>">
					<td><%=name%></td>
					<td><%=minQuant%></td>
					<td><%=maxQuant%></td>
					<td><%=quantity%></td>
					<td><button type="button" onclick="editButton(<%=id%>)">Update</button></td>
				</tr>
				
				<%
				
				
			


			}
		
		%>


	</tbody>
	</table>
	
	
	<hr />
	
	
    
    <div id="updatepopup" style="background-color:white; text-align:center; display:none; position: fixed;top: 20%;z-index: 2;">
    	<form id="finalSubmit" action="inventoryTransaction" method="post">
    		<input id="productIDUpdate" type="hidden" name="id" />
			<input type="hidden" name="invUserID" value="<%=userID %>" />
			New Quantity value: <input id="newQuant" type="text" name="quantity" size="20"  />
			<button type="button" onclick="saveButton()">save</button>
			<button type="button" onclick="cancelButton()">cancel</button>
    	</form>
    </div>
    
    
    <%
    }
	%>
    


  </body>
</html>