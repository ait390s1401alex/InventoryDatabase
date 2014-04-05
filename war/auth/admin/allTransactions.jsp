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
    	document.getElementById("view"+ID).style.display = "none";
    	document.getElementById("edit"+ID).style.display = "";
    }
    
    function cancelButton(ID) {
    	document.getElementById("view"+ID).style.display = "";
    	document.getElementById("edit"+ID).style.display = "none";
    }
    
    function deleteButton(ID) {
    	window.location = 'deleteTransaction?id=' + ID;
    }
    
    function saveButton(ID) {
    	$("#invTransactionIDUpdate").val(ID);
    	$("#invUserIDUpdate").val($("#invUserID"+ID).val());
    	$("#productIDUpdate").val($("#productID"+ID).val());
    	$("#transQuantityUpdate").val($("#transQuantity"+ID).val());
    	document.forms["finalSubmit"].submit();
    }
    
    $(document).ready(function() {
        $('#maintable').dataTable();
    } );
    
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
				<td><%=invUserID%></td>
				<td><%=productID %></td>
				<td><%=transQuantity %></td>
				<td><%=dateText %></td>
				<td><%=transDate %></td>
				<td><button type="button" onclick="editButton(<%=invTransID%>)">Edit</button></td>
				<td><button type="button" onclick="deleteButton(<%=invTransID%>)">Delete</button></td>
		</tr>
		
		<tr id="edit<%=invTransID%>" style="display: none">
				<td><input id="invUserID<%=invTransID%>" type="text" name="invUserID" value="<%=invUserID%>" size="20" disabled="disabled" /></td>
				<td><input id="productID<%=invTransID%>" type="text" name="productID" value="<%=productID%>" size="20" disabled="disabled"/></td>
				<td><input id="transQuantity<%=invTransID%>" type="text" name="transQuantity" value="<%=transQuantity%>" size="20" /></td>
				<td><input id="transDate<%=invTransID%>" type="text" name="transDate" value="<%=dateText%>" size="20" disabled="disabled" /></td>
				<td><input type="text" name="dateValue" value="<%=transDate%>" size="20" disabled="disabled" /></td>
				<td><button type="button" onclick="cancelButton(<%=invTransID%>)">cancel</button><button type="button" onclick="saveButton(<%=invTransID%>)">save</button></td>
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
    
    <div>
    	<form id="finalSubmit" action="updateTransaction" method="post">
	    	<input id="invTransactionIDUpdate" type="hidden" name="id" />
	    	<input id="invUserIDUpdate" type="hidden" name="invUserID" />
			<input id="productIDUpdate" type="hidden" name="productID"  />
			<input id="transQuantityUpdate" type="hidden" name="transQuantity"  />
    	</form>
    </div>

</div>
  </body>

</html>