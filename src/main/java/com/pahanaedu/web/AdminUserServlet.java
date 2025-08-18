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

    @Override protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String username=req.getParameter("username");
        String password=req.getParameter("password");
        String role=req.getParameter("role");
        service.create(username,password,role);
        resp.sendRedirect(req.getContextPath()+"/admin/users");
    }
}
