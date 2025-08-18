package com.pahanaedu.web;

import com.pahanaedu.model.LogEntry;
import com.pahanaedu.service.LogService;
import com.pahanaedu.service.impl.LogServiceImpl;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/logs")
public class LogsServlet extends HttpServlet {
  private final LogService service = new LogServiceImpl();

  @Override
  protected void doGet(HttpServletRequest req, HttpServletResponse resp)
      throws ServletException, IOException {

    // Admin only
    HttpSession s = req.getSession(false);
    String role = (s==null)? null : (String) s.getAttribute("role");
    if (role==null || !"ADMIN".equals(role)) {
      resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Admins only");
      return;
    }

    String user = req.getParameter("user");
    String action = req.getParameter("action");
    String period = req.getParameter("period"); // today/last7/last30/all
    if (period==null || period.isBlank()) period = "today";
    int limit = 300;

    List<LogEntry> logs = service.search(user, action, period, limit);
    req.setAttribute("logs", logs);
    req.setAttribute("userQ", user);
    req.setAttribute("actionQ", action);
    req.setAttribute("period", period);
    req.getRequestDispatcher("/views/admin/logs.jsp").forward(req, resp);
  }
}
