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

    // 1) LOGOUT event එක log කරන්න (session invalidate කරලා ඊලගට)
    try {
      LogService logService = new LogServiceImpl();
      logService.log(req, "LOGOUT", "USER", null);
    } catch (Exception ignore) {
      // logging failure shouldn't block logout
    }

    // 2) Session invalidate
    HttpSession s = req.getSession(false);
    if (s != null) s.invalidate();

    // 3) JSESSIONID cookie expire කරලා දාමු (optional but good)
    Cookie kill = new Cookie("JSESSIONID", "");
    kill.setMaxAge(0);
    kill.setHttpOnly(true);
    // context path correct කරන්න
    String ctx = req.getContextPath();
    kill.setPath((ctx == null || ctx.isBlank()) ? "/" : ctx);
    resp.addCookie(kill);

    // 4) cache-prevent headers
    resp.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    resp.setHeader("Pragma", "no-cache");
    resp.setDateHeader("Expires", 0);

    // 5) Redirect to login with a flag so UI can show "You have logged out"
    resp.sendRedirect((ctx == null ? "" : ctx) + "/login?out=1");
  }
}
