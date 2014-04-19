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
<%@ page import="inventory.db.Product" %>
<%@ page import="inventory.db.InvUser" %>
<%@ page import="inventory.db.Rental" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.TimeZone" %>
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
    <script type="text/javascript" charset="utf-8" src="/DataTables/media/js/jquery.js"></script>
	<script type="text/javascript" charset="utf-8" src="/DataTables/media/js/jquery.dataTables.js"></script>
    
    <script>
	

    function editButton(ID) {
    	$("#rentTransactionIDUpdate").val(ID);
    	$("#invUserIDUpdate").val($("#invUserID"+ID).val());
    	$("#rentalIDUpdate").val($("#rentalID"+ID).val());
    	$("#inOutUpdate").val($("#inOut"+ID).val());
    	$("#dateUpdate").val($("#date"+ID).val());
    	$("#customerUpdate").val($("#customer"+ID).val());
    	var pos = $("#view" + ID).position();
	    	var wid = $("#view" + ID).width();
	    	$("#editpop").css({
	            position: "absolute",
	            top: (pos.top - 0) + "px",
	            left: (wid/2 - 100) + "px",
	            width: 500 + "px"
	        }).show();
	    document.getElementById("editpop").style.display = "";
    }
    
    function cancelButton() {
    	document.getElementById("editpop").style.display = "none";
    }
    
    function deleteButton(ID) {
    	if(confirm('Are you sure you want to delete this Rental Transaction?')){
    		window.location = 'deleteRentalTransaction?id=' + ID;
    	}else{
    	
    	}
    	
    }
    
    function saveButton() {
    	document.forms["finalSubmit"].submit();
    }
    
    function popup(){
    	var pos = $("#menudrop").position();
    	var wid = $("#menudrop").width();
    	$("#popup").css({
            position: "absolute",
            top: (pos.top + 15) + "px",
            left: pos.left + "px",
            width: wid + "px"
        }).show();
    	document.getElementById("popup").style.display = "";
    }
    function popoff(){
    	document.getElementById("popup").style.display = "none";
    }
    
    $(document).ready(function() {
        $('#maintable').dataTable();
    } );
    
    </script>
    
  </head>
  
  	

  <body>
  <div class="topbar"></div>
  <div class="background">
  
	  
	  			    <%
				    UserService userService = UserServiceFactory.getUserService();
				    User user = userService.getCurrentUser();
				    if (user != null) {
				    	Entity invUser = InvUser.getInvUserWithLoginID(user.getNickname());
				      	pageContext.setAttribute("user", user);
					%>
						<div class="top" style="float:left">
							<a href="/home.jsp">HOME</a> | 
							<a href="/auth/user/rental.jsp">RENTAL</a> | 
							<a href="/auth/user/inventory.jsp">INVENTORY</a> | 
							<a href="/auth/admin/admin.jsp">ADMIN</a>
						</div>
						<div class="top" id="menudrop" style="float:right"><a href="#" onmouseover="popup();" onmouseout="popoff();"><%=InvUser.getFirstName(invUser)%> <%=InvUser.getLastName(invUser)%></a></div>
						<div id="popup" class="popup" onmouseover="popup();" onmouseout="popoff();" style="display:none">
						<ul>
							<li><a href="/editProfile.jsp" >PROFILE</a></li>
							<li><a href="/logout">LOGOUT</a></li>
						</ul>
						</div>
						<br />
						<br />
						
					
					<%
	    } else {
	    	%>
			<jsp:forward page="/index.jsp" />
		<%
		    }
		List<Entity> allTransactions = RentTransaction.getFirstRentTransactions(100);
		if (allTransactions.isEmpty()) {
	%>
	<h1>No transactions to display</h1>
	<%
		}else{	
	%>
	
	<h1>All Transactions</h1>
	<table id="maintable" border="1">
	<thead>
		<tr>
			<th>UserID</th>
			<th>RentalID</th>
			<th>In/Out</th>
			<th>Date</th>
			<th>Customer</th>
			<th>Edit</th>
			<th>Delete</th>
		</tr>
		</thead>
		<tbody>
		<%
			for (Entity rentTransaction : allTransactions) {
					String invUserID = InvUser.getLoginID(InvUser.getInvUser(RentTransaction.getInvUserID(rentTransaction)));
					String rentalID = Rental.getName(Rental.getRental(RentTransaction.getRentalID(rentTransaction)));
					String inOut = RentTransaction.getInOut(rentTransaction);
					String transDate = RentTransaction.getDateValue(rentTransaction);
					Date date = new Date(Long.parseLong(transDate));
					SimpleDateFormat df2 = new SimpleDateFormat("MM/dd/yy hh:mm");
					df2.setTimeZone(TimeZone.getTimeZone("America/New_York"));
					String dateText = df2.format(date);
					
					String customer = RentTransaction.getCustomer(rentTransaction);
					String rentTransID = RentTransaction.getStringID(rentTransaction);
		%>

		<tr id="view<%=rentTransID%>">
				<td><%=invUserID%><input id="invUserID<%=rentTransID%>" type="text" name="invUserID" value="<%=invUserID%>" size="20" disabled="disabled" hidden="true" /></td>
				<td><%=rentalID%><input id="rentalID<%=rentTransID%>" type="text" name="rentalID" value="<%=rentalID%>" size="20" disabled="disabled" hidden="true" /></td>
				<td><%=inOut%><input id="inOut<%=rentTransID%>" type="text" name="inOut" value="<%=inOut%>" size="20" hidden="true" /></td>
				<td><%=dateText%><input id="date<%=rentTransID%>" type="text" name="date" value="<%=dateText%>" size="20" disabled="disabled" hidden="true" /></td>
				<td><%=customer%><input id="customer<%=rentTransID%>" type="text" name="customer" value="<%=customer%>" size="20" hidden="true" /></td>
				<td><button type="button" onclick="editButton(<%=rentTransID%>)">Edit</button></td>
				<td><button type="button" onclick="deleteButton(<%=rentTransID%>)">Delete</button></td>
		</tr>
		
		
		<%
			}

		}
		%>
	</tbody>
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
    
    <div id="editpop" class="editpop" style="display:none">
    	<form id="finalSubmit" action="updateRentalTransaction" method="post">
	    	<input id="rentTransactionIDUpdate" type="hidden" name="id" />
    		<table class="tablepop">
	    		<tr><td>User: </td><td><input id="invUserIDUpdate" type="text" disabled="disabled" name="invUserID" /></td></tr>
				<tr><td>Rental: </td><td><input id="rentalIDUpdate" type="text" disabled="disabled" name="rentalID"  /></td></tr>
				<tr><td>In/Out: </td><td><input id="inOutUpdate" type="text" name="inOut"  /></td></tr>
				<tr><td>Date: </td><td><input id="dateUpdate" type="text" name="date"  /></td></tr>
				<tr><td>Customer: </td><td><input id="customerUpdate" type="text" name="customer"  /></td></tr>
				<tr><td colspan="2"><button type="button" onclick="cancelButton()">cancel</button><button type="button" id="savebutton" onclick="saveButton()">save</button></td></tr>
    		</table>
    	</form>
    </div>

</div>
  </body>

</html>