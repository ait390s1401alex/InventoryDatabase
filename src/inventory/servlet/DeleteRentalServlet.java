/**
 * Copyright 2014 -
 * Licensed under the Academic Free License version 3.0
 * http://opensource.org/licenses/AFL-3.0
 * 
 * Authors: Alex Verkhovtsev
 */


package inventory.servlet;

import inventory.db.Rental;

import javax.servlet.http.*;
import javax.servlet.ServletException;

import java.io.IOException;


public class DeleteRentalServlet extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	@Override
    public void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
		String id = req.getParameter("id");
        Rental.deleteRental(id);
        resp.sendRedirect("allRentalItems.jsp");
		
    }
	
	@Override
    public void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
		String id = req.getParameter("id");
        Rental.deleteRental(id);
        resp.sendRedirect("allRentalItems.jsp");
		
    }


}
