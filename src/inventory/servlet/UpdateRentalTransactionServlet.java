/**
 * Copyright 2014 -
 * Licensed under the Academic Free License version 3.0
 * http://opensource.org/licenses/AFL-3.0
 * 
 * Authors: Alex Verkhovtsev
 */


package inventory.servlet;

import inventory.db.RentTransaction;

import javax.servlet.http.*;
import javax.servlet.ServletException;

import java.io.IOException;
import java.util.Date;


public class UpdateRentalTransactionServlet extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
		
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String id = req.getParameter("id");
		String invUserID = req.getParameter("invUserID");
		String rentalID = req.getParameter("rentalID");
        String inOut = req.getParameter("inOut");
        String date = req.getParameter("date");
        String customer = req.getParameter("customer");

        RentTransaction.updateRentTransaction(id, invUserID, rentalID,  inOut,  date, customer);
        resp.sendRedirect("allRentalTransactions.jsp");
}


}
