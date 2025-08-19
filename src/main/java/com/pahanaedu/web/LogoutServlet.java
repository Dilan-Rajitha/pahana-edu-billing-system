package com.pahanaedu.web;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;

import com.pahanaedu.service.LogService;
import com.pahanaedu.service.impl.LogServiceImpl;

@WebServlet("/logout")
public class LogoutServlet extends HttpServlet {
  @Override
  protected void doGet(HttpServletRequest req, HttpServletResponse resp)
      throws ServletException, IOException {

    try {
      LogService logService = new LogServiceImpl();
      logService.log(req, "LOGOUT", "USER", null);
    } catch (Exception ignore) {
    }

    HttpSession s = req.getSession(false);
    if (s != null) s.invalidate();

    Cookie kill = new Cookie("JSESSIONID", "");
    kill.setMaxAge(0);
    kill.setHttpOnly(true);
    String ctx = req.getContextPath();
    kill.setPath((ctx == null || ctx.isBlank()) ? "/" : ctx);
    resp.addCookie(kill);

    resp.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    resp.setHeader("Pragma", "no-cache");
    resp.setDateHeader("Expires", 0);

    resp.sendRedirect((ctx == null ? "" : ctx) + "/login?out=1");
  }
}
