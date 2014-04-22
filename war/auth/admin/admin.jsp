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
    <meta http-equiv="content-type" content="text/html; charset=UTF-8">
    <link type="text/css" rel="stylesheet" href="/stylesheets/user.css" />
    <title>Economy Party Supplies - Inventory Management - Administration</title>
    
    <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js"></script>
    
    <script>
    
    	function generateReport(){
    		var type = $("#selectedReport :selected").val();
    		if(type == "outOfStock"){
    			window.open('reports/outofstock.jsp', '_blank');
    		}
    		if(type == "lowStock"){
    			window.open('reports/lowstock.jsp', '_blank');
    		}
    		if(type == "earningsProduct"){
    			window.open('reports/earningsperproduct.jsp', '_blank');
    		}
    		if(type == "productSold"){
    			window.open('reports/productsold.jsp', '_blank');
    		}
    		if(type == "earningsProductMonth"){
    			var pos = $("#selectedReport").position();
	    		var wid = $("#selectedReport").width();
    			$("#monthpop").css({
		            position: "absolute",
		            top: (pos.top + 30) + "px",
		            left: pos.left + (wid/2) - 75 + "px",
		            width: "200px"
		        }).show();
		    	document.getElementById("monthpop").style.display = "";
    		}
    		if(type == "productSoldMonth"){
    			var pos = $("#selectedReport").position();
	    		var wid = $("#selectedReport").width();
    			$("#monthpop").css({
		            position: "absolute",
		            top: (pos.top + 30) + "px",
		            left: pos.left + (wid/2) - 75 + "px",
		            width: "200px"
		        }).show();
		    	document.getElementById("monthpop").style.display = "";
    		}
    		
    	}
    	
    	
    	
    	function monthReport(){
    		var type = $("#selectedReport :selected").val();
    		var mon = $("#selectedMonth :selected").val();
    		var year = $("#selectedYear").val();
    		if(type == "earningsProductMonth"){
    			window.open('reports/earningspermonth.jsp?mon=' + mon + '&year=' + year, '_blank');
    			document.getElementById("monthpop").style.display = "none";
    		}
    		if(type == "productSoldMonth"){
    			window.open('reports/productsoldmonth.jsp?mon=' + mon + '&year=' + year, '_blank');
    			document.getElementById("monthpop").style.display = "none";
    		}
    		
    	}
    	
    	
    	function cancelMonth(){
    		document.getElementById("monthpop").style.display = "none";
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
    </script>
    
  </head>

  <body>
  
  <div class="topbar"></div>
  <div class="background" id="background">
  
	  
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
	
    <h1>Economy Party Supplies - Administration</h1>
    
    
    <p><a href="allProducts.jsp">Show all Products</a></p>
    <p><a href="allUsers.jsp">Show all Users</a></p>
	<p><a href="allTransactions.jsp">Show all Transactions</a></p>
	
	<hr />
	
	<p><a href="allRentalItems.jsp">Show all Rental Items</a></p>
	<p><a href="allRentalTransactions.jsp">Show all Rental Transactions</a></p>
	
	<hr />
	<h2>Reports</h2>
		<select name="reportType" id="selectedReport">
			<option value="lowStock">All Products Low on Stock</option>
			<option value="outOfStock">All Products Out of Stock</option>
			<option value="earningsProductMonth">Earnings per Product for Month</option>
			<option value="productSoldMonth">Quantity Sold per Product for Month</option>
			<option value="earningsProduct">Total Earnings per Product - All time</option>
			<option value="productSold">Total Quantity Sold per Product - All time</option>
		</select>
		<button type="button" onclick="generateReport()">Submit</button>
	</div>
	
	<div id="monthpop" class="monthpop" style="display:none">
	<table class="monthtable">
	<tr><td>Month: </td>
	<td>
		<select name="month" id="selectedMonth">
			<option value="01">January</option>
			<option value="02">February</option>
			<option value="03">March</option>
			<option value="04">April</option>
			<option value="05">May</option>
			<option value="06">June</option>
			<option value="07">July</option>
			<option value="08">August</option>
			<option value="09">September</option>
			<option value="10">October</option>
			<option value="11">November</option>
			<option value="12">December</option>
		</select>
		</td>
		</tr>
		<tr><td>Year: </td>
		<td>
		<input type="text" id="selectedYear" size="4" />
		</td>
		</tr>
		<tr>
		<td colspan="2">
		<button type="button" onclick="monthReport()">Submit</button>
		<button type="button" onclick="cancelMonth()">Cancel</button>
		</td>
		</tr>
		</table>
	</div>
  </body>
</html>
