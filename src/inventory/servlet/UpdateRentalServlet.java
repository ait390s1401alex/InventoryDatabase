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


public class UpdateRentalServlet extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
		
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String id = req.getParameter("id");
		String name = req.getParameter("name");
		String description = req.getParameter("description");
        String price = req.getParameter("price");
        String isRented = req.getParameter("isRented");

        
        Rental.updateRental(id, name, description,  price,  isRented);
        resp.sendRedirect("allRentalItems.jsp");
}


}
