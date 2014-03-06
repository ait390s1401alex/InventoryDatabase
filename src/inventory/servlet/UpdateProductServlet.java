/**
 * Copyright 2014 -
 * Licensed under the Academic Free License version 3.0
 * http://opensource.org/licenses/AFL-3.0
 * 
 * Authors: Alex Verkhovtsev
 */


package inventory.servlet;

import inventory.db.Product;

import javax.servlet.http.*;
import javax.servlet.ServletException;

import java.io.IOException;


public class UpdateProductServlet extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
		
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String id = req.getParameter("id");
		String productName = req.getParameter("productName");
		String quantity = req.getParameter("quantity");
        String purchasePrice = req.getParameter("purchasePrice");
        String salesPrice = req.getParameter("salesPrice");
        String minQuantity = req.getParameter("minQuantity");
        String maxQuantity = req.getParameter("maxQuantity");
        
        Product.updateProduct(id, productName, quantity,  purchasePrice,  salesPrice, minQuantity,  maxQuantity);
        resp.sendRedirect("allProducts.jsp");
}


}
