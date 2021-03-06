/**
 * Copyright 2014 -
 * Licensed under the Academic Free License version 3.0
 * http://opensource.org/licenses/AFL-3.0
 * 
 * Authors: Alex Verkhovtsev
 */



package inventory.servlet;


import java.io.IOException;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;


import com.google.appengine.api.datastore.Entity;
import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;

import inventory.db.InvUser;

@SuppressWarnings("serial")
public class LoginSessionServlet extends HttpServlet {


    @Override
    public void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        UserService userService = UserServiceFactory.getUserService();
        User user = userService.getCurrentUser(); // or req.getUserPrincipal()
        
        HttpSession session = req.getSession();
                
        synchronized (session) {
			if (user == null) {
				resp.sendRedirect("/error.html");
			}else{
				session.setAttribute("user", user.getUserId());
				session.setAttribute("isAdmin", "false");
				session.setAttribute("isStandarduser", "false");
				if(InvUser.getInvUserWithLoginID(user.getNickname()) == null){
					session.setAttribute("isAdmin", "false");
					session.setAttribute("isStandarduser", "false");
				}else if(InvUser.getIsAdmin(InvUser.getInvUserWithLoginID(user.getNickname())).equals("true")){
					session.setAttribute("isAdmin", "true");
					session.setAttribute("isStandardUser", "true");
				}else if(InvUser.getIsStandardUser(InvUser.getInvUserWithLoginID(user.getNickname())).equals("true")){
					session.setAttribute("isStandardUser", "true");
				}
				resp.sendRedirect("/index.jsp");
			}

		}
		
    	resp.sendRedirect("/index.jsp");

    }
    
}