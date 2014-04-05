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
import java.util.Date;


public class UpdateTransactionServlet extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
		
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String id = req.getParameter("id");
        String transQuantity = req.getParameter("transQuantity");

        InvTransaction.updateInvTransaction(id, transQuantity);
        resp.sendRedirect("allTransactions.jsp");
}


}
