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
    <link type="text/css" rel="stylesheet" href="/stylesheets/user.css" />
    
    <title>Economy Party Supplies - Rental Items</title>
    
    
    
        <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js"></script>
        <script type="text/javascript" charset="utf-8" src="/DataTables/media/js/jquery.js"></script>
		<script type="text/javascript" charset="utf-8" src="/DataTables/media/js/jquery.dataTables.js"></script>
    
    <script>
	

    function editButton(ID) {
    	var pos = $("#view" + ID).position();
    	var wid = $("#view" + ID).width()
    	$("#rentalIDUpdate").val(ID);
    	$("#isRentedUpdate").val($("#isRented"+ID).val());
    	$("#customerpopup").css({
            position: "absolute",
            top: (pos.top + 15) + "px",
            left: pos.left + wid/2 - (wid/2 + 100)/2 + "px",
            width: wid/2 + 100 + "px",
            height: 40 + "px"
        }).show();
    	document.getElementById("customerpopup").style.display = "";
    	document.getElementById("newCust").focus();
    }
    
    function cancelButton(ID) {
    	document.getElementById("customerpopup").style.display = "none";
    }
    
    
    function saveButton() {
    	document.getElementById("customerpopup").style.display = "none";
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
        $('#maintable').dataTable( {
            "iDisplayLength": 50
        } );
    } );
    
    </script>
    
  </head>
  
  	

  <body>
  
<div class="topbar"></div>
<div class="backgroundwrapper">
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
	%>
  
  
	<%
		List<Entity> allRentTransactions = RentTransaction.getRentTransactionsWithOut(100);
		List<Entity> allRentals = Rental.getFirstRentals(100);
		if (allRentals.isEmpty()) {
	%>
	<h1>No Rental Items Entered</h1>
	<%
		}else{	
			
			String userID = InvUser.getStringID(InvUser.getInvUserWithLoginID(user.getNickname()));
	%>
	<h1>All Rentals</h1>
	
	<table id="maintable" border="1">
	<thead>
		<tr>
			<th>Item Name</th>
			<th>Description</th>
			<th>Rental Price</th>
			<th>Customer</th>
			<th>Rent/Return</th>
		</tr>
		</thead>
		<tbody>
		<%
		for (Entity rental : allRentals) {
			String name = Rental.getName(rental);
			String description = Rental.getDescription(rental);
			String price = Rental.getPrice(rental);
			String isRented = Rental.getIsRented(rental);
			String id = Rental.getStringID(rental);
			String cust = "";
			for(Entity rentTrans : allRentTransactions){
				if((RentTransaction.getRentalID(rentTrans)).equals(id) ){
					cust = RentTransaction.getCustomer(rentTrans);
					break;
				}
			}
			
			if(isRented.equals("true")){
				
				%>

				<tr id="view<%=id%>">
					<td class="invname"><%=name%></td>
					<td><%=description%></td>
					<td><%=price%> per day</td>
					<td><%=cust%><input id="isRented<%=id%>" type="hidden" name="isRented" value="<%=isRented%>" /></td>
					<td><button type="button" onclick="editButton(<%=id%>)">Return</button></td>
				</tr>
				
				<%
				
				
			}else{
				
				%>

				<tr id="view<%=id%>">
					<td class="invname"><%=name%></td>
					<td><%=description%></td>
					<td><%=price%> per day</td>
					<td>-----<input id="isRented<%=id%>" type="hidden" name="isRented" value="<%=isRented%>" /></td>
					<td><button type="button" onclick="editButton(<%=id%>)">Rent</button></td>
				</tr>
				
				<%
				
				
			}


			}
		
		%>


	</tbody>
	</table>
	
	
	<hr />
	
	
    
    <div id="customerpopup" class="updatepopup" style="display: none" >
    	<form id="finalSubmit" action="rentTransaction" method="post">
    		<input id="rentalIDUpdate" type="hidden" name="id" />
			<input id="isRentedUpdate" type="hidden" name="isRented"  />
			<input type="hidden" name="invUserID" value="<%=userID %>" />
			Customer Information: <input id="newCust" type="text" name="customer" size="20" />
			<button type="button" onclick="saveButton()">save</button>
			<button type="button" onclick="cancelButton()">cancel</button>
    	</form>
    </div>
    
    
    <%
    }
	%>
    

</div>
</div>
  </body>
</html>