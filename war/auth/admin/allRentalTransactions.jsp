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
<%@ page import="inventory.db.RentTransaction" %>
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
    
    <title>Economy Party Supplies - Admin - Rental Transactions</title>
    
    
    <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js"></script>
    
    <script>
	

    function editButton(ID) {
    	document.getElementById("view"+ID).style.display = "none";
    	document.getElementById("edit"+ID).style.display = "";
    }
    
    function cancelButton(ID) {
    	document.getElementById("view"+ID).style.display = "";
    	document.getElementById("edit"+ID).style.display = "none";
    }
    
    function deleteButton(ID) {
    	window.location = 'deleteRentalTransaction?id=' + ID;
    }
    
    function saveButton(ID) {
    	$("#rentTransactionIDUpdate").val(ID);
    	$("#invUserIDUpdate").val($("#invUserID"+ID).val());
    	$("#rentalIDUpdate").val($("#rentalID"+ID).val());
    	$("#inOutUpdate").val($("#inOut"+ID).val());
    	$("#dateUpdate").val($("#date"+ID).val());
    	$("#customerUpdate").val($("#customer"+ID).val());
    	document.forms["finalSubmit"].submit();
    }
    
    </script>
    
  </head>
  
  	

  <body>
  <div class="background" align="center">

  
  	<a href="admin.jsp">return to admin main</a>
  	<a href="/index.jsp">home</a>
  
  <%
    UserService userService = UserServiceFactory.getUserService();
    User user = userService.getCurrentUser();
    if (user != null) {
      	pageContext.setAttribute("user", user);
	%>
		<p>Hello, ${fn:escapeXml(user.nickname)}! (You can <a href="/logout">sign out</a>.)</p>
	<%
	    }else {
	    	%>
			<c:redirect url="/index.jsp" />
		<%
		    }
		%>
  
	<%
		List<Entity> allTransactions = RentTransaction.getFirstRentTransactions(100);
		if (allTransactions.isEmpty()) {
	%>
	<h1>No transactions to display</h1>
	<%
		}else{	
	%>
	
	<h1>All Transactions</h1>
	<table border="1">
		<tr>
			<td>UserID</td>
			<td>RentalID</td>
			<td>In/Out</td>
			<td>date</td>
			<td>Customer</td>
			<td>Edit</td>
			<td>Delete</td>
		</tr>
		<%
			for (Entity rentTransaction : allTransactions) {
					String invUserID = RentTransaction.getInvUserID(rentTransaction);
					String rentalID = RentTransaction.getRentalID(rentTransaction);
					String inOut = RentTransaction.getInOut(rentTransaction);
					String date = RentTransaction.getDate(rentTransaction);
					String customer = RentTransaction.getCustomer(rentTransaction);
					String rentTransID = RentTransaction.getStringID(rentTransaction);
		%>

		<tr id="view<%=rentTransID%>">
				<td><%=invUserID%></td>
				<td><%=rentalID %></td>
				<td><%=inOut %></td>
				<td><%=date %></td>
				<td><%=customer %></td>
				<td><button type="button" onclick="editButton(<%=rentTransID%>)">Edit</button></td>
				<td><button type="button" onclick="deleteButton(<%=rentTransID%>)">Delete</button></td>
		</tr>
		
		<tr id="edit<%=rentTransID%>" style="display: none">
				<td><input id="invUserID<%=rentTransID%>" type="text" name="invUserID" value="<%=invUserID%>" size="20" /></td>
				<td><input id="rentalID<%=rentTransID%>" type="text" name="rentalID" value="<%=rentalID%>" size="20" /></td>
				<td><input id="inOut<%=rentTransID%>" type="text" name="inOut" value="<%=inOut%>" size="20" /></td>
				<td><input id="date<%=rentTransID%>" type="text" name="date" value="<%=date%>" size="20" /></td>
				<td><input id="customer<%=rentTransID%>" type="text" name="customer" value="<%=customer%>" size="20" /></td>
				<td><button type="button" onclick="cancelButton(<%=rentTransID%>)">cancel</button><button type="button" onclick="saveButton(<%=rentTransID%>)">save</button></td>
				<td><button type="button" onclick="deleteButton(<%=rentTransID%>)">Delete</button></td>		
		</tr>
		
		<%
			}

		}
		%>

	</table>
	


	<hr />
	<form action="addRentalTransaction" method="post">
	<table>
		<tr>
	    	<td>InvUser ID</td><td><input type="text" name="invUserID" size="20" /></td>
    	</tr>
    	<tr>
			<td>Rental ID</td><td><input type="text" name="rentalID" size="20" /></td>
		</tr>
		<tr>
			<td>In / Out</td><td><input type="text" name="inOut" size="20" /></td>
		</tr>
		<tr>
			<td>Date</td><td><input type="text" name="date" size="20" /></td>
		</tr>
		<tr>
			<td>Customer</td><td><input type="text" name="customer" size="20" /></td>
		</tr>
	</table>
		<input type="submit" value="Add Transaction" />
    </form>
    
    <div>
    	<form id="finalSubmit" action="updateRentalTransaction" method="post">
	    	<input id="rentTransactionIDUpdate" type="hidden" name="id" />
	    	<input id="invUserIDUpdate" type="hidden" name="invUserID" />
			<input id="rentalIDUpdate" type="hidden" name="rentalID"  />
			<input id="inOutUpdate" type="hidden" name="inOut"  />
			<input id="dateUpdate" type="hidden" name="date"  />
			<input id="customerUpdate" type="hidden" name="customer"  />
    	</form>
    </div>

</div>
  </body>

</html>