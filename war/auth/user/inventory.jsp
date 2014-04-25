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
    <link type="text/css" rel="stylesheet" href="/stylesheets/user.css" />
    
    <title>Economy Party Supplies - Inventory</title>
    
    
    
        <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js"></script>
        <script type="text/javascript" charset="utf-8" src="/DataTables/media/js/jquery.js"></script>
		<script type="text/javascript" charset="utf-8" src="/DataTables/media/js/jquery.dataTables.js"></script>
    
    <script>
	

    function editButton(ID) {
    	var pos = $("#view" + ID).position();
    	var wid = $("#view" + ID).width()
    	$("#productIDUpdate").val(ID);
    	$("#updatepopup").css({
            position: "absolute",
            top: (pos.top + 15) + "px",
            left: pos.left + wid/2 - (wid/2 + 100)/2 + "px",
            width: wid/2 + 100 + "px",
            height: 40 + "px"
        }).show();
    	
    	document.getElementById("newquant").focus();
    }
    
    function cancelButton(ID) {
    	document.getElementById("updatepopup").style.display = "none";
    }
    
    
    function saveButton() {
    	document.getElementById("updatepopup").style.display = "none";
    	
    	var intRegex = /^\d+$/;
    	if(intRegex.test($("#newQuant").val())) {
    		document.forms["finalSubmit"].submit();
    	}else{
    		alert('Invalid entry. Please only enter a non negative integer.');
    	}
    	
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
					<td class="invname"><%=name%></td>
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
	
	
    
    <div id="updatepopup" class="updatepopup" style="display: none">
    	<form id="finalSubmit" action="inventoryTransaction" method="post" >
    		<input id="productIDUpdate" type="hidden" name="id" />
			<input type="hidden" name="invUserID" value="<%=userID %>" />
			New Quantity value: <input id="newQuant" type="text" name="quantity" size="20" />
			<button type="button" onclick="saveButton()">save</button>
			<button type="button" onclick="cancelButton()">cancel</button>
    	</form>
    </div>
    
    
    <%
    }
	%>
    

</div>
  </body>
</html>