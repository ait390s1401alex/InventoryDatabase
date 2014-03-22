/**
 * Copyright 2014 -
 * Licensed under the Academic Free License version 3.0
 * http://opensource.org/licenses/AFL-3.0
 * 
 * Authors: Alex Verkhovtsev
 */


package inventory.servlet;

import inventory.db.InvUser;

import javax.servlet.http.*;
import javax.servlet.ServletException;

import java.io.IOException;

public class AddUserServlet extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
		
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		String loginID = req.getParameter("loginID");
		String firstName = req.getParameter("firstName");
        String lastName = req.getParameter("lastName");
        String isAdmin = req.getParameter("isAdmin");
        String isStandardUser = req.getParameter("isStandardUser");
        
        InvUser.createInvUser(loginID, firstName, lastName, isAdmin, isStandardUser);
        
        if(req.getRequestURI().equals("/auth/admin/addUser")){
        	resp.sendRedirect("allUsers.jsp");
        }else{
        	resp.sendRedirect("index.jsp");
        }
        
	}


}
