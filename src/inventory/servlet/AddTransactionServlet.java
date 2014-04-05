/**
 * Copyright 2014 -
 * Licensed under the Academic Free License version 3.0
 * http://opensource.org/licenses/AFL-3.0
 * 
 * Authors: Alex Verkhovtsev
 */


package inventory.servlet;

import inventory.db.InvTransaction;
import inventory.db.Product;

import javax.servlet.http.*;
import javax.servlet.ServletException;

import java.io.IOException;

public class AddTransactionServlet extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
		
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		if(req.getRequestURI().equals("/auth/admin/addInventoryTransaction")){
			String invUserID = req.getParameter("invUserID");
	        String productID = req.getParameter("productID");
	        String transQuantity = req.getParameter("transQuantity");
	        
	        InvTransaction.createInvTransaction(invUserID, productID, transQuantity);
	        resp.sendRedirect("allTransactions.jsp");
	        
		}else if(req.getRequestURI().equals("/auth/user/inventoryTransaction")){
			String invUserID = req.getParameter("invUserID");
	        String productID = req.getParameter("id");
	        String quantity = req.getParameter("quantity");
	        
	        int transQuantInt = (Integer.parseInt(quantity))- Integer.parseInt((Product.getQuantity(Product.getProduct(productID))));
	        
	        if(Product.setQuantity(productID, quantity) == true){
	        	InvTransaction.createInvTransaction(invUserID, productID, transQuantInt + "");
		        resp.sendRedirect("inventory.jsp");
	        }
	        resp.sendRedirect("/error.html");
	        
		}
		resp.sendRedirect("/error.html");
		
	}


}
