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
    	$("#isStandardUserUpdate").val($("#isStandardUser"+ID).val());
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
							<li><a href="editProfile.jsp" >PROFILE</a></li>
							<li><a href="/logout" onmouseover="popup();">LOGOUT</a></li>
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
			<td>User ID</td>
			<td>First Name</td>
			<td>Last Name</td>
			<td>isAdmin</td>
			<td>isAuthenticatedUser</td>
			<td>Edit</td>
			<td>Delete</td>
		</tr>
		<%
			for (Entity invUser : allUsers) {
					String firstName = InvUser.getFirstName(invUser);
					String lastName = InvUser.getLastName(invUser);
					String isAdmin = InvUser.getIsAdmin(invUser);
					String isStandardUser = InvUser.getIsStandardUser(invUser);
					String invUserID = InvUser.getStringID(invUser);
					String loginID = InvUser.getLoginID(invUser);
		%>

		<tr id="view<%=invUserID%>">
				<td><%=loginID %></td>
				<td><%=firstName%></td>
				<td><%=lastName %></td>
				<td><%=isAdmin %></td>
				<td><%=isStandardUser %></td>
				<td><button type="button" onclick="editButton(<%=invUserID%>)">Edit</button></td>
				<td><button type="button" onclick="deleteButton(<%=invUserID%>)">Delete</button></td>
		</tr>
		
		<tr id="edit<%=invUserID%>" style="display: none">
				<td><input id="loginID<%=invUserID%>" type="text" name="loginID" value="<%=loginID%>" size="20" disabled="disabled" /></td>
				<td><input id="firstName<%=invUserID%>" type="text" name="firstName" value="<%=firstName%>" size="20" /></td>
				<td><input id="lastName<%=invUserID%>" type="text" name="lastName" value="<%=lastName%>" size="20" /></td>
				<td><input id="isAdmin<%=invUserID%>" type="text" name="isAdmin" value="<%=isAdmin%>" size="20" /></td>
				<td><input id="isStandardUser<%=invUserID%>" type="text" name="isStandardUser" value="<%=isStandardUser%>" size="20" /></td>
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
			<td>Login ID</td><td><input type="text" name="loginID" size="20" /></td>
		</tr>
		<tr>
	    	<td>First Name</td><td><input type="text" name="firstName" size="20" /></td>
    	</tr>
    	<tr>
			<td>Last Name</td><td><input type="text" name="lastName" size="20" /></td>
		</tr>
		<tr>
			<td>isAdmin</td><td><input type="text" name="isAdmin" size="20" /></td>
		</tr>
		<tr>
			<td>isStandardUser</td><td><input type="text" name="isStandardUser" size="20" /></td>
		</tr>
	</table>
		<input type="submit" value="Add User" />
    </form>
    
    <div>
    	<form id="finalSubmit" action="updateUser" method="post">
	    	<input id="invUserIDUpdate" type="hidden" name="id" />
	    	<input id="firstNameUpdate" type="hidden" name="firstName" />
			<input id="lastNameUpdate" type="hidden" name="lastName"  />
			<input id="isAdminUpdate" type="hidden" name="isAdmin"  />
			<input id="isStandardUserUpdate" type="hidden" name="isStandardUser"  />
    	</form>
    </div>

</div>
  </body>

</html>