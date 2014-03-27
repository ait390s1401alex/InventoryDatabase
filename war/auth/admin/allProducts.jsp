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
    
    <title>Economy Party Supplies - Admin - Products</title>
    
    
    
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
    	window.location = 'deleteProduct?id=' + ID;
    }
    
    function saveButton(ID) {
    	$("#savebutton"+ID).attr("disabled", "disabled");
    	$("#productIDUpdate").val(ID);
    	$("#productNameUpdate").val($("#productName"+ID).val());
    	$("#quantityUpdate").val($("#quantity"+ID).val());
    	$("#purchasePriceUpdate").val($("#purchasePrice"+ID).val());
    	$("#salesPriceUpdate").val($("#salesPrice"+ID).val());
    	$("#minQuantityUpdate").val($("#minQuantity"+ID).val());
    	$("#maxQuantityUpdate").val($("#maxQuantity"+ID).val());
    	document.forms["finalSubmit"].submit();
    }
    
    </script>
    
  </head>
  
  	

  <body>
  
  
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
	    } else {
	    	%>
			<c:redirect url="/index.jsp" />
		<%
		    }
	%>
  
  
	<%
		List<Entity> allProducts = Product.getFirstProducts(100);
		if (allProducts.isEmpty()) {
	%>
	<h1>No Products Entered</h1>
	<%
		}else{	
	%>
	<h1>All Products</h1>
	
	<table border="1">
		<tr>
			<td>Product</td>
			<td>Quantity</td>
			<td>Purchase Price</td>
			<td>Sales Price</td>
			<td>Min Quantity</td>
			<td>Max Quantity</td>
			<td>Edit</td>
			<td>Deleted Product</td>
		</tr>
		<%
		for (Entity product : allProducts) {
			String productName = Product.getName(product);
			String quantity = Product.getQuantity(product);
			String purchasePrice = Product.getPurchasePrice(product);
			String salesPrice = Product.getSalesPrice(product);
			String minQuantity = Product.getMinQuantity(product);
			String maxQuantity = Product.getMaxQuantity(product);
			String id = Product.getStringID(product);
		%>

		<tr id="view<%=id%>">
			<td><%=productName%></td>
			<td><%=quantity%></td>
			<td><%=purchasePrice%></td>
			<td><%=salesPrice%></td>
			<td><%=minQuantity%></td>
			<td><%=maxQuantity%></td>
			<td><button type="button" onclick="editButton(<%=id%>)">Edit</button></td>
			<td><button type="button" onclick="deleteButton(<%=id%>)">Delete</button></td>
		</tr>
		
		<tr id="edit<%=id%>" style="display: none">
				<td><input id="productName<%=id%>" type="text" name="productName" value="<%=productName%>" size="20"/></td>
				<td><input id="quantity<%=id%>" type="text" name="quantity" value="<%=quantity%>" size="20" /></td>
				<td><input id="purchasePrice<%=id%>" type="text" name="purchasePrice" value="<%=purchasePrice%>" size="20" /></td>
				<td><input id="salesPrice<%=id%>" type="text" name="salesPrice" value="<%=salesPrice%>" size="20" /></td>
				<td><input id="minQuantity<%=id%>" type="text" name="minQuantity" value="<%=minQuantity%>" size="20" /></td>
				<td><input id="maxQuantity<%=id%>" type="text" name="maxQuantity" value="<%=maxQuantity%>" size="20" /></td>
				<td><button type="button" onclick="cancelButton(<%=id%>)">cancel</button><button type="button" id="savebutton<%=id%>" onclick="saveButton(<%=id%>)">save</button></td>
				<td><button type="button" onclick="deleteButton(<%=id%>)">Delete</button></td>		
		</tr>
		
		<%
			}

		}
		%>

	</table>
	
	
	<hr />
    <form action="addProduct" method="post">
    <table>
    	<tr>
    		<td>Product Name: </td><td><input type="text" name="productName" size="50" /></td>
    	</tr>
    	<tr>
	    		<td>Quantity: </td><td><input type="text" name="quantity" size="50" /></td>
    	</tr>
    	<tr>
	    		<td>Purchase Price: </td><td><input type="text" name="purchasePrice" size="50" /></td>
    	</tr>
    	<tr>
	    		<td>Sales Price: </td><td><input type="text" name="salesPrice" size="50" /></td>
    	</tr>
    	<tr>
	    		<td>Min Quantity Defined: </td><td><input type="text" name="minQuantity" size="50" /></td>
    	</tr>
    	<tr>
	    		<td>Max Quantity Defined: </td><td><input type="text" name="maxQuantity" size="50" /></td>
    	</tr>
     </table>
      <div><input type="submit" value="Add Product" /></div>
    </form>
    
    
    <div>
    	<form id="finalSubmit" action="updateProduct" method="post">
    		<input id="productIDUpdate" type="hidden" name="id" />
	    	<input id="productNameUpdate" type="hidden" name="productName" />
	    	<input id="quantityUpdate" type="hidden" name="quantity" />
			<input id="purchasePriceUpdate" type="hidden" name="purchasePrice"  />
			<input id="salesPriceUpdate" type="hidden" name="salesPrice"  />
			<input id="minQuantityUpdate" type="hidden" name="minQuantity"  />
			<input id="maxQuantityUpdate" type="hidden" name="maxQuantity"  />
    	</form>
    </div>

  </body>
</html>