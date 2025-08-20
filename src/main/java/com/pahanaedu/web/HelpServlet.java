package com.pahanaedu.web;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/help")
public class HelpServlet extends HttpServlet {
  @Override
  protected void doGet(HttpServletRequest req, HttpServletResponse resp)
      throws ServletException, IOException {

    HttpSession s = req.getSession(false);
    String role = (s == null) ? null : (String) s.getAttribute("role");
    if (role == null) {
      resp.sendRedirect(req.getContextPath() + "/login");
      return;
    }

    // optional
    String topic = req.getParameter("topic");
    if (topic != null) req.setAttribute("topic", topic);

    if ("ADMIN".equals(role)) {
      req.getRequestDispatcher("/views/help/admin.jsp").forward(req, resp);
    } else {
      req.getRequestDispatcher("/views/help/staff.jsp").forward(req, resp);
    }
  }
}
