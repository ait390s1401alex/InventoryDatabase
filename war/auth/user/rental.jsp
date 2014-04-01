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
<%@ page import="inventory.db.Rental" %>
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
    
    <title>Economy Party Supplies - Rental Items</title>
    
    
    
        <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js"></script>
    
    <script>
	

    function editButton(ID) {
    	$("#rentalIDUpdate").val(ID);
    	$("#isRentedUpdate").val($("#isRented"+ID).val());
    	document.getElementById("customerpopup").style.display = "";
    }
    
    function cancelButton(ID) {
    	document.getElementById("customerpopup").style.display = "none";
    }
    
    
    function saveButton() {
    	document.getElementById("customerpopup").style.display = "none";
    	document.forms["finalSubmit"].submit();
    }
    
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
		List<Entity> allRentals = Rental.getFirstRentals(100);
		if (allRentals.isEmpty()) {
	%>
	<h1>No Rental Items Entered</h1>
	<%
		}else{	
			
			String userID = InvUser.getStringID(InvUser.getInvUserWithLoginID(user.getNickname()));
	%>
	<h1>All Rentals</h1>
	
	<table border="1">
		<tr>
			<td>Item Name</td>
			<td>Description</td>
			<td>Rental Price</td>
			<td>isRented</td>
			<td>Edit</td>
		</tr>
		<%
		for (Entity rental : allRentals) {
			String name = Rental.getName(rental);
			String description = Rental.getDescription(rental);
			String price = Rental.getPrice(rental);
			String isRented = Rental.getIsRented(rental);
			String id = Rental.getStringID(rental);
			
			if(isRented.equals("true")){
				
				%>

				<tr id="view<%=id%>">
					<td><%=name%></td>
					<td><%=description%></td>
					<td><%=price%> per day</td>
					<td><%=isRented%><input id="isRented<%=id%>" type="hidden" name="isRented" value="<%=isRented%>" /></td>
					<td><button type="button" onclick="editButton(<%=id%>)">Return</button></td>
				</tr>
				
				<%
				
				
			}else{
				
				%>

				<tr id="view<%=id%>">
					<td><%=name%></td>
					<td><%=description%></td>
					<td><%=price%> per day</td>
					<td><%=isRented%><input id="isRented<%=id%>" type="hidden" name="isRented" value="<%=isRented%>" /></td>
					<td><button type="button" onclick="editButton(<%=id%>)">Rent</button></td>
				</tr>
				
				<%
				
				
			}


			}
		
		%>



	</table>
	
	
	<hr />
	
	
    
    <div id="customerpopup" style="background-color:white; text-align:center; display:none; position: fixed;top: 20%;z-index: 2;">
    	<form id="finalSubmit" action="rentTransaction" method="post">
    		<input id="rentalIDUpdate" type="hidden" name="id" />
			<input id="isRentedUpdate" type="hidden" name="isRented"  />
			<input type="hidden" name="invUserID" value="<%=userID %>" />
			Customer Information: <input type="text" name="customer" size="20"  />
			<button type="button" onclick="saveButton()">save</button>
			<button type="button" onclick="cancelButton()">cancel</button>
    	</form>
    </div>
    
    
    <%
    }
	%>
    


  </body>
</html>