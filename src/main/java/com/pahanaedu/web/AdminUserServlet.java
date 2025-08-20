package com.pahanaedu.web;

import com.pahanaedu.model.User;
import com.pahanaedu.service.UserService;
import com.pahanaedu.service.impl.UserServiceImpl;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/admin/users")
public class AdminUserServlet extends HttpServlet {
    private final UserService service = new UserServiceImpl();

    @Override protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String action = req.getParameter("action");
        if ("delete".equals(action)) {
            Long id = Long.valueOf(req.getParameter("id"));
            service.delete(id);
            resp.sendRedirect(req.getContextPath()+"/admin/users");
            return;
        }
        List<User> users = service.all();
        req.setAttribute("users", users);
        req.getRequestDispatcher("/views/admin/users.jsp").forward(req, resp);
    }

    
  //Old one befor the same username error
//    @Override protected void doPost(HttpServletRequest req, HttpServletResponse resp)
//            throws ServletException, IOException {
//        String username=req.getParameter("username");
//        String password=req.getParameter("password");
//        String role=req.getParameter("role");
//        service.create(username,password,role);
//        resp.sendRedirect(req.getContextPath()+"/admin/users");
//    }
    
  //new one after the same username error
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String username = req.getParameter("username");
        String password = req.getParameter("password");
        String role = req.getParameter("role");

        try {
            // Try to create the user
            service.create(username, password, role);
            resp.sendRedirect(req.getContextPath() + "/admin/users");  // Redirect after successful creation
        } catch (RuntimeException e) {
            // Set the error message and users list in the request to forward them back to the page
            req.setAttribute("error", e.getMessage());  // Set the error message
            List<User> users = service.all();  // Reload users list
            req.setAttribute("users", users);  // Set the users list in the request
            req.getRequestDispatcher("/views/admin/users.jsp").forward(req, resp);  // Forward back to the page
        }
    }


}
