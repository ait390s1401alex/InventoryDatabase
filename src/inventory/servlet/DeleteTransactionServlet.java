/**
 * Copyright 2014 -
 * Licensed under the Academic Free License version 3.0
 * http://opensource.org/licenses/AFL-3.0
 * 
 * Authors: Alex Verkhovtsev
 */


package inventory.servlet;

import inventory.db.InvTransaction;

import javax.servlet.http.*;
import javax.servlet.ServletException;

import java.io.IOException;

public class DeleteTransactionServlet extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	

		public void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
			String id = req.getParameter("id");
	        InvTransaction.deleteInvTransaction(id);
	        resp.sendRedirect("allTransactions.jsp");
			
	    }
		
		@Override
	    public void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
			String id = req.getParameter("id");
	        InvTransaction.deleteInvTransaction(id);
	        resp.sendRedirect("allTransactions.jsp");
			
	    }


}
