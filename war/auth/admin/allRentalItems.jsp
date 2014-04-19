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
    
    <title>Economy Party Supplies - Admin - Rental Items</title>
    
    
    
        <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js"></script>
        <script type="text/javascript" charset="utf-8" src="/DataTables/media/js/jquery.js"></script>
		<script type="text/javascript" charset="utf-8" src="/DataTables/media/js/jquery.dataTables.js"></script>
    
    <script>
	

    function editButton(ID) {
    	$("#savebutton"+ID).attr("disabled", "disabled");
    	$("#rentalIDUpdate").val(ID);
    	$("#nameUpdate").val($("#name"+ID).val());
    	$("#descriptionUpdate").val($("#description"+ID).val());
    	$("#priceUpdate").val($("#price"+ID).val());
    	$("#isRentedUpdate").val($("#isRented"+ID).val());
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
    	if(confirm('Are you sure you want to delete this Rental Item?')){
    		window.location = 'deleteRental?id=' + ID;
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
    
    $(document).ready( function () {
        $("#maintable").dataTable();
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

		List<Entity> allRentals = Rental.getFirstRentals(100);
		if (allRentals.isEmpty()) {
	%>
	<h1>No Rental Items Entered</h1>
	<%
		}else{	
	%>
	<h1>All Rentals</h1>
	
	<table id="maintable" border="1">
	<thead>
		<tr>
			<th>Item Name</th>
			<th>Description</th>
			<th>Rental Price</th>
			<th>isRented</th>
			<th>Edit</th>
			<th>Delete Product</th>
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
		%>

		<tr id="view<%=id%>">
			<td><%=name%><input id="name<%=id%>" type="text" name="name" value="<%=name%>" size="20" hidden="true" /></td>
			<td><%=description%><input id="description<%=id%>" type="text" name="description" value="<%=description%>" size="20" hidden="true" /></td>
			<td><%=price%><input id="price<%=id%>" type="text" name="price" value="<%=price%>" size="20" hidden="true" /></td>
			<td><%=isRented%><input id="isRented<%=id%>" type="text" name="isRented" value="<%=isRented%>" size="20"  hidden="true"/></td>
			<td><button type="button" onclick="editButton(<%=id%>)">Edit</button></td>
			<td><button type="button" onclick="deleteButton(<%=id%>)">Delete</button></td>
		</tr>
	
		
		<%
			}

		}
		%>
	</tbody>
	</table>
	
	
	<hr />
    <form action="addRental" method="post">
    <table>
    	<tr>
    		<td>Rental Item Name: </td><td><input type="text" name="name" size="50" /></td>
    	</tr>
    	<tr>
	    		<td>Description: </td><td><input type="text" name="description" size="50" /></td>
    	</tr>
    	<tr>
	    		<td>Rental Price: </td><td><input type="text" name="price" size="50" /></td>
    	</tr>
    	<tr>
	    		<td>isRented: </td><td><input type="text" name="isRented" size="50" /></td>
    	</tr>
     </table>
      <div><input type="submit" value="Add Rental" /></div>
    </form>
    
    
    <div id="editpop" class="editpop" style="display:none">
    	<form id="finalSubmit" action="updateRental" method="post">
    		<input id="rentalIDUpdate" type="hidden" name="id" />
    		<table class="tablepop">
    		<tr><td>Rental Name: </td><td><input id="nameUpdate" type="text" name="name" /></td></tr>
	    	<tr><td>Description: </td><td><input id="descriptionUpdate" type="text" name="description" /></td></tr>
			<tr><td>Price: </td><td><input id="priceUpdate" type="text" name="price"  /></td></tr>
			<tr><td>Is Rented?: </td><td><input id="isRentedUpdate" type="text" name="isRented"  /></td></tr>
			<tr><td colspan="2"><button type="button" onclick="cancelButton()">cancel</button><button type="button" id="savebutton" onclick="saveButton()">save</button></td></tr>
    	</table>
    	</form>
    </div>
	</div>
  </body>
</html>