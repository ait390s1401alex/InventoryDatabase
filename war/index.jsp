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
  </head>

  <body>
  <div class="background">
	  <table>
	  		<tr>
	  			<td><h1>Economy Party Supplies Inventory Management</h1></td>
	  		</tr>
	  		
	  		<tr>
	  			<td>
	  			    <%
				    UserService userService = UserServiceFactory.getUserService();
				    User user = userService.getCurrentUser();
				    if (user != null) {
					%>
						<jsp:forward page="/home.jsp" />					
					<%
						Entity invUser = InvUser.getInvUserWithLoginID(user.getNickname());
					
					    } else {
					    	
					    	%>
			    	Sign in below.<br />
					    	<%
					    	
					    	final Map<String, String> openIdProviders;
					            openIdProviders = new HashMap<String, String>();
					            openIdProviders.put("Google", "https://www.google.com/accounts/o8/id");
					    	
					    	for (String providerName : openIdProviders.keySet()) {
				                out.println("[<a href=\"/_ah/login_required?provider=" + providerName + "\">" + providerName + "</a>] ");
				            }

					    }
				    
					%>
				</td>
	  		</tr>
	  </table>

    
	</div>
	</body>
</html>
