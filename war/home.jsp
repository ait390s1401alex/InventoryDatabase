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

<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.HashSet" %>
<%@ page import="java.util.Map" %>
<%@ page import="javax.servlet.http.HttpServletRequest" %>
<%@ page import="javax.servlet.http.HttpSession" %>
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
    <meta http-equiv="content-type" content="text/html; charset=UTF-8">
        <link type="text/css" rel="stylesheet" href="/stylesheets/user.css" />
    <title>Economy Party Supplies - Inventory Management</title>
    
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
				    	if(invUser == null){
							%>
							<jsp:forward page="/editProfile.jsp" />
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
						
						
							<div id="main">
					<table>
				  		<tr>
				  			<td><h1>Economy Party Supplies Inventory Management</h1></td>
				  		</tr>
				  		
				  		<tr>
				  			<td>
							
							</td>
							</tr>
							<tr>
							<td><h1>Welcome <%=InvUser.getFirstName(invUser) %>!</h1></td>
							</tr>
							<tr>
							<td>
								<p>TODO - INSERT IMAGE HERE</p>

							
							
							<%
						}
					
					    } else {
					    	
					    	
					    	%>
							<jsp:forward page="/index.jsp" />
							<%

					    }
				    
					%>
				</td>
	  		</tr>
	  </table>
	  </div>
	  </div>

    

  </body>
</html>
