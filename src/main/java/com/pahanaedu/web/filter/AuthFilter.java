package com.pahanaedu.web.filter;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.Set;

public class AuthFilter implements Filter {

  private static final Set<String> PUBLIC_EXACT = Set.of(
      "/", "/index.jsp", "/login" , "/logout"
  );

  @Override
  public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
      throws IOException, ServletException {

    HttpServletRequest r = (HttpServletRequest) req;
    HttpServletResponse w = (HttpServletResponse) res;

    String ctx = r.getContextPath();
    String path = r.getRequestURI().substring(ctx.length());

    HttpSession session = r.getSession(false);
    String role = (session == null) ? null : (String) session.getAttribute("role");
    boolean logged = (role != null);

    // allow exact-public and common static/view folders (you keep JSPs outside WEB-INF)
    boolean isPublicExact = PUBLIC_EXACT.contains(path);
    boolean isStatic = path.startsWith("/assets/") || path.startsWith("/css/")
                    || path.startsWith("/js/") || path.startsWith("/images/");
    boolean isLoginView = path.startsWith("/views/auth/"); // allow login JSP direct if needed

    if (isPublicExact || isStatic || isLoginView) {
      chain.doFilter(req, res);
      return;
    }

    if (!logged) {
      w.sendRedirect(ctx + "/login");
      return;
    }

    // ADMIN-only area (/admin/*)
    if (path.startsWith("/admin/") && !"ADMIN".equals(role)) {
      w.sendError(HttpServletResponse.SC_FORBIDDEN, "Admins only");
      return;
    }

    chain.doFilter(req, res);
  }
}
