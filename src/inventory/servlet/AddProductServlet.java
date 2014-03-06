/**
 * Copyright 2014 -
 * Licensed under the Academic Free License version 3.0
 * http://opensource.org/licenses/AFL-3.0
 * 
 * Authors: Alex Verkhovtsev
 */


package inventory.servlet;

import javax.servlet.http.*;
import javax.servlet.ServletException;

import java.io.IOException;

import inventory.db.Product;

public class AddProductServlet extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
		
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String productName = req.getParameter("productName");
        Product.createProduct(productName);
        resp.sendRedirect("allProducts.jsp");
}


}
