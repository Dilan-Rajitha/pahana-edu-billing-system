package com.pahanaedu.web;

import com.pahanaedu.service.AuthService;
import com.pahanaedu.service.impl.AuthServiceImpl;
// 🔽 add
import com.pahanaedu.service.LogService;
import com.pahanaedu.service.impl.LogServiceImpl;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private final AuthService auth = new AuthServiceImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession s = req.getSession(false);
        if (s != null && s.getAttribute("user") != null) {
            resp.sendRedirect(req.getContextPath() + "/dashboard");
            return;
        }
        if ("1".equals(req.getParameter("out"))) {
            req.setAttribute("info", "You have been logged out.");
        }
        req.getRequestDispatcher("/views/auth/login.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String u = req.getParameter("username");
        String p = req.getParameter("password");

        String role = auth.authenticate(u, p);
        if (role != null) {
            HttpSession s = req.getSession(true);
            s.setAttribute("user", u);
            s.setAttribute("role", role);

            // ✅ LOGIN success → write log
            LogService logService = new LogServiceImpl();
            logService.log(req, "LOGIN", "USER", null);

            resp.sendRedirect(req.getContextPath() + "/dashboard");
        } else {
            // (optional) LOGIN_FAIL log (see tweak in LogServiceImpl below)
            // new LogServiceImpl().log(req, "LOGIN_FAIL", "USER", null);

            req.setAttribute("error", "Invalid username or password");
            req.setAttribute("username", u);
            req.getRequestDispatcher("/views/auth/login.jsp").forward(req, resp);
        }
    }
}
