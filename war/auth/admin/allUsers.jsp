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
    $("#invUserIDUpdate").val(ID);
    	$("#firstNameUpdate").val($("#firstName"+ID).val());
    	$("#lastNameUpdate").val($("#lastName"+ID).val());
    	$("#isAdminUpdate").val($("#isAdmin"+ID).val());
    	$("#isStandardUserUpdate").val($("#isStandardUser"+ID).val());
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
    	if(confirm('Are you sure you want to delete this User?')){
    		window.location = 'deleteUser?id=' + ID;
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
				<td><%=loginID %><input id="loginID<%=invUserID%>" type="text" name="loginID" value="<%=loginID%>" size="20" disabled="disabled" hidden="true" /></td>
				<td><%=firstName%><input id="firstName<%=invUserID%>" type="text" name="firstName" value="<%=firstName%>" size="20" hidden="true" /></td>
				<td><%=lastName %><input id="lastName<%=invUserID%>" type="text" name="lastName" value="<%=lastName%>" size="20" hidden="true" /></td>
				<td><%=isAdmin %><input id="isAdmin<%=invUserID%>" type="text" name="isAdmin" value="<%=isAdmin%>" size="20" hidden="true" /></td>
				<td><%=isStandardUser %><input id="isStandardUser<%=invUserID%>" type="text" name="isStandardUser" value="<%=isStandardUser%>" size="20" hidden="true" /></td>
				<td><button type="button" onclick="editButton(<%=invUserID%>)">Edit</button></td>
				<td><button type="button" onclick="deleteButton(<%=invUserID%>)">Delete</button></td>
		</tr>
		
		
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
    
    <div id="editpop" class="editpop" style="display:none">
    	<form id="finalSubmit" action="updateUser" method="post">
	    	<input id="invUserIDUpdate" type="hidden" name="id" />
	    	<table class="tablepop">
	    		<tr><td>First Name: </td><td><input id="firstNameUpdate" type="text" name="firstName" /></td></tr>
				<tr><td>Last Name: </td><td><input id="lastNameUpdate" type="text" name="lastName"  /></td></tr>
				<tr><td>Is Admin?: </td><td><input id="isAdminUpdate" type="text" name="isAdmin"  /></td></tr>
				<tr><td>Is User?: </td><td><input id="isStandardUserUpdate" type="text" name="isStandardUser"  /></td></tr>
				<tr><td colspan="2"><button type="button" onclick="cancelButton()">cancel</button><button type="button" id="savebutton" onclick="saveButton()">save</button></td></tr>
    		</table>
    	</form>
    </div>

</div>
  </body>

</html>