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
<%@ page import="inventory.db.InvTransaction" %>
<%@ page import="inventory.db.InvUser" %>
<%@ page import="inventory.db.Product" %>
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
    
    <title>Economy Party Supplies - Admin - Transactions</title>
    
    
    <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js"></script>
    <script type="text/javascript" charset="utf-8" src="/DataTables/media/js/jquery.js"></script>
	<script type="text/javascript" charset="utf-8" src="/DataTables/media/js/jquery.dataTables.js"></script>
    
    <script>
	

    function editButton(ID) {
    	$("#invTransactionIDUpdate").val(ID);
    	$("#invUserIDUpdate").val($("#invUserID"+ID).val());
    	$("#productIDUpdate").val($("#productID"+ID).val());
    	$("#transQuantityUpdate").val($("#transQuantity"+ID).val());
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
    	if(confirm('Are you sure you want to delete this Transaction?')){
    		window.location = 'deleteTransaction?id=' + ID;
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
		List<Entity> allTransactions = InvTransaction.getFirstInvTransactions(100);
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
			<th>Product</th>
			<th>Transaction Quantity</th>
			<th>Transaction Date</th>
			<th>Date Sort Value</th>
			<th>Edit</th>
			<th>Delete</th>
		</tr>
		</thead>
		<tbody>
		<%
			for (Entity invTransaction : allTransactions) {
					String invUserID = InvUser.getLoginID(InvUser.getInvUser(InvTransaction.getInvUserID(invTransaction)));
					String productID = Product.getName(Product.getProduct(InvTransaction.getProductID(invTransaction)));
					String transQuantity = InvTransaction.getTransQuantity(invTransaction);
					String transDate = InvTransaction.getTransDate(invTransaction);
					Date date = new Date(Long.parseLong(transDate));
					SimpleDateFormat df2 = new SimpleDateFormat("MM/dd/yy hh:mm");
					df2.setTimeZone(TimeZone.getTimeZone("America/New_York"));
			        String dateText = df2.format(date);
					
					String invTransID = InvTransaction.getStringID(invTransaction);
		%>

		<tr id="view<%=invTransID%>">
				<td><%=invUserID%><input id="invUserID<%=invTransID%>" type="text" name="invUserID" value="<%=invUserID%>" size="20" disabled="disabled" hidden="true" /></td>
				<td><%=productID %><input id="productID<%=invTransID%>" type="text" name="productID" value="<%=productID%>" size="20" disabled="disabled" hidden="true" /></td>
				<td><%=transQuantity %><input id="transQuantity<%=invTransID%>" type="text" name="transQuantity" value="<%=transQuantity%>" size="20" hidden="true" /></td>
				<td><%=dateText %><input id="transDate<%=invTransID%>" type="text" name="transDate" value="<%=dateText%>" size="20" disabled="disabled" hidden="true" /></td>
				<td><%=transDate %><input type="text" name="dateValue" value="<%=transDate%>" size="20" disabled="disabled" hidden="true" /></td>
				<td><button type="button" onclick="editButton(<%=invTransID%>)">Edit</button></td>
				<td><button type="button" onclick="deleteButton(<%=invTransID%>)">Delete</button></td>
		</tr>
		
		
		<%
			}

		}
		%>
	</tbody>
	</table>
	


	<hr />
	<form action="addTransaction" method="post">
	<table>
		<tr>
			<td>InvUser ID</td>
			<td>Product ID</td>
			<td>Transaction Quantity</td>
		</tr>
		<tr>
	    	<td><input type="text" name="invUserID" size="20" /></td>
			<td><input type="text" name="productID" size="20" /></td>
			<td><input type="text" name="transQuantity" size="20" /></td>
		</tr>
	</table>
		<input type="submit" value="Add Transaction" />
    </form>
    
    <div id="editpop" class="editpop" style="display:none">
    	<form id="finalSubmit" action="updateTransaction" method="post">
	    	<input id="invTransactionIDUpdate" type="hidden" name="id" />
	    	<table class="tablepop">
    			<tr><td>User: </td><td><input id="invUserIDUpdate" type="text" name="invUserID" disabled="disabled" /></td></tr>
				<tr><td>Product: </td><td><input id="productIDUpdate" type="text" name="productID"  disabled="disabled" /></td></tr>
				<tr><td>Quantity: </td><td><input id="transQuantityUpdate" type="text" name="transQuantity"  /></td></tr>
				<tr><td colspan="2"><button type="button" onclick="cancelButton()">cancel</button><button type="button" id="savebutton" onclick="saveButton()">save</button></td></tr>
    		</table>
    	</form>
    </div>

</div>
  </body>

</html>