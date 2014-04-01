/**
 * Copyright 2014 -
 * Licensed under the Academic Free License version 3.0
 * http://opensource.org/licenses/AFL-3.0
 * 
 * Authors: Alex Verkhovtsev
 */


package inventory.servlet;

import inventory.db.RentTransaction;
import inventory.db.Rental;

import javax.servlet.http.*;
import javax.servlet.ServletException;

import java.io.IOException;

public class AddRentalTransactionServlet extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
		
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		
		if(req.getRequestURI().equals("/auth/admin/addRentalTransaction")){
			String invUserID = req.getParameter("invUserID");
	        String rentalID = req.getParameter("rentalID");
	        String inOut = req.getParameter("inOut");
	        String date = req.getParameter("date");
	        String customer = req.getParameter("customer");
	        
	        RentTransaction.createRentTransaction(invUserID, rentalID, inOut, date, customer);
	        resp.sendRedirect("allRentalTransactions.jsp");
	        
        }else if(req.getRequestURI().equals("/auth/user/rentTransaction")){
        	String rentalID = req.getParameter("id");
        	String invUserID = req.getParameter("invUserID");
        	String isRented = req.getParameter("isRented");
        	String customer = req.getParameter("customer");
        	String inOut = " ";
        	
        	if(isRented.equals("true")){
        		inOut = "In";
        		Rental.setIsRented(rentalID, "false");
        	}else if(isRented.equals("false")){
        		inOut = "Out";
        		Rental.setIsRented(rentalID, "true");
        	}
        	RentTransaction.createRentTransaction(invUserID, rentalID, inOut, customer);
        	resp.sendRedirect("rental.jsp");
        }
		
		

	}


}
