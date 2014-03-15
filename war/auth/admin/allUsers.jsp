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
    <link type="text/css" rel="stylesheet" href="/stylesheets/main.css" />
    
    <title>Economy Party Supplies - Admin - Users</title>
    
    
    <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js"></script>
    
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
    	window.location = 'deleteUser?id=' + ID;
    }
    
    function saveButton(ID) {
    	$("#invUserIDUpdate").val(ID);
    	$("#firstNameUpdate").val($("#firstName"+ID).val());
    	$("#lastNameUpdate").val($("#lastName"+ID).val());
    	$("#isAdminUpdate").val($("#isAdmin"+ID).val());
    	document.forms["finalSubmit"].submit();
    }
    
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
	    }
	%>
  
  
	<%
		List<Entity> allUsers = InvUser.getFirstInvUsers(100);
		if (allUsers.isEmpty()) {
	%>
	<h1>No Users in DB</h1>
	<%
		}else{	
	%>
	
	<h1>All Users</h1>
	<table border="1">
		<tr>
			<td>First Name</td>
			<td>Last Name</td>
			<td>isAdmin</td>
			<td>Edit</td>
			<td>Delete</td>
		</tr>
		<%
			for (Entity invUser : allUsers) {
					String firstName = InvUser.getFirstName(invUser);
					String lastName = InvUser.getLastName(invUser);
					String isAdmin = InvUser.getIsAdmin(invUser);
					String invUserID = InvUser.getStringID(invUser);
		%>

		<tr id="view<%=invUserID%>">
				<td><%=firstName%></td>
				<td><%=lastName %></td>
				<td><%=isAdmin %></td>
				<td><button type="button" onclick="editButton(<%=invUserID%>)">Edit</button></td>
				<td><button type="button" onclick="deleteButton(<%=invUserID%>)">Delete</button></td>
		</tr>
		
		<tr id="edit<%=invUserID%>" style="display: none">
				<td><input id="firstName<%=invUserID%>" type="text" name="firstName" value="<%=firstName%>" size="20" /></td>
				<td><input id="lastName<%=invUserID%>" type="text" name="lastName" value="<%=lastName%>" size="20" /></td>
				<td><input id="isAdmin<%=invUserID%>" type="text" name="isAdmin" value="<%=isAdmin%>" size="20" /></td>
				<td><button type="button" onclick="cancelButton(<%=invUserID%>)">cancel</button><button type="button" onclick="saveButton(<%=invUserID%>)">save</button></td>
				<td><button type="button" onclick="deleteButton(<%=invUserID%>)">Delete</button></td>		</tr>
		
		<%
			}

		}
		%>

	</table>
	


	<hr />
	<form action="addUser" method="post">
	<table>
		<tr>
			<td>First Name</td>
			<td>Last Name</td>
			<td>isAdmin</td>
		</tr>
		<tr>
	    	<td><input type="text" name="firstName" size="20" /></td>
			<td><input type="text" name="lastName" size="20" /></td>
			<td><input type="text" name="isAdmin" size="20" /></td>
		</tr>
	</table>
		<input type="submit" value="Add User" />
    </form>
    
    <div>
    	<form id="finalSubmit" action="updateUser" method="post">
	    	<input id="invUserIDUpdate" type="hidden" name="id" value="" />
	    	<input id="firstNameUpdate" type="hidden" name="firstName" />
			<input id="lastNameUpdate" type="hidden" name="lastName"  />
			<input id="isAdminUpdate" type="hidden" name="isAdmin"  />
    	</form>
    </div>

</div>
  </body>

</html>