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
    
    <title>Economy Part Supply</title>
    
    <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js"></script>
    
    <script>
    
    
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
  <div class="background">
  
	  
	  			    <%
				    UserService userService = UserServiceFactory.getUserService();
				    User user = userService.getCurrentUser();
				    if (user != null) {
				    	Entity invUser = InvUser.getInvUserWithLoginID(user.getNickname());
				      	pageContext.setAttribute("user", user);
	 
    
    if(invUser == null){
    	%>
    	<div class="top" style="float:left">
			<a href="/home.jsp">HOME</a> | 
			<a href="/auth/user/rental.jsp">RENTAL</a> | 
			<a href="/auth/user/inventory.jsp">INVENTORY</a> | 
			<a href="/auth/admin/admin.jsp">ADMIN</a>
		</div>
		<div class="top" id="menudrop" style="float:right"><a href="#" onmouseover="popup();" onmouseout="popoff();"><%=user.getNickname()%></a></div>
		<div id="popup" class="popup" onmouseover="popup();" onmouseout="popoff();" style="display:none">
		<ul>
			<li><a href="editProfile.jsp" >PROFILE</a></li>
			<li><a href="/logout" onmouseover="popup();">LOGOUT</a></li>
		</ul>
		</div>
		<br />
		<br />
						
    	<h2>Welcome <%=user.getNickname() %>! Please enter some basic information.</h2>
		<form action="addUser" method="post">
			<table >
				<tr>
					<td>First Name: </td><td><input type="text" name="firstName" size="30"  required /></td>
				</tr>
				<tr>
					<td>Last Name: </td><td><input type="text" name="lastName" size="30" required /></td>
				</tr>
				
			</table>
			<input type="hidden" name="loginID" value="<%=user.getNickname()%>" />
			<input type="submit" value="Update" />
		</form>
    	
    	<%
    }else{
    	
    	
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
			<li><a href="editProfile.jsp" >PROFILE</a></li>
			<li><a href="/logout" onmouseover="popup();">LOGOUT</a></li>
		</ul>
		</div>
		<br />
		<br />
						
		<h2>Welcome <%=InvUser.getFirstName(invUser) %>! Edit your profile below!</h2>
		<form action="updateUser" method="post">
			<table>
				<tr>
					<td>First Name: </td><td><input type="text" name="firstName" size="30" value="<%=InvUser.getFirstName(invUser)%>" required /></td>
				</tr>
				<tr>
					<td>Last Name: </td><td><input type="text" name="lastName" size="30" value="<%=InvUser.getLastName(invUser) %>" required /></td>
				</tr>
				
				
			</table>
			<input type="hidden" name="loginID" value="<%=user.getNickname()%>" />
			<input type="hidden" name="id" value="<%=InvUser.getStringID(invUser)%>" />
			<input type="hidden" name="isAdmin" value="<%=InvUser.getIsAdmin(invUser) %>" />
			<input type="hidden" name="isStandardUser" value="<%=InvUser.getIsStandardUser(invUser) %>" />
			<input type="submit" value="update" />
		</form>

	<%
    	
    	
    	
    
    
    }
				    }else{
				    	%>
				    		<jsp:forward page="index.jsp" />
				    	<%
				    	}
    
	%>
  
	</div>
  </body>
 
</html>