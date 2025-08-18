// DashboardServlet.java
package com.pahanaedu.web;

import com.pahanaedu.dao.BillingDAO;
import com.pahanaedu.dao.CustomerDAO;
import com.pahanaedu.dao.ItemDAO;
import com.pahanaedu.dao.impl.BillingDAOImpl;
import com.pahanaedu.dao.impl.CustomerDAOImpl;
import com.pahanaedu.dao.impl.ItemDAOImpl;
import com.pahanaedu.model.Bill;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {

  private final CustomerDAO customerDao = new CustomerDAOImpl();
  private final ItemDAO itemDao = new ItemDAOImpl();
  private final BillingDAO billingDao = new BillingDAOImpl();

  @Override
  protected void doGet(HttpServletRequest req, HttpServletResponse resp)
      throws ServletException, IOException {

    HttpSession s = req.getSession(false);
    if (s == null || s.getAttribute("user") == null) {
      resp.sendRedirect(req.getContextPath() + "/login");
      return;
    }

    // counts (common)
    try { req.setAttribute("customerCount", customerDao.countAll()); }
    catch (RuntimeException ex) { req.setAttribute("customerCount", 0); log("customer count failed", ex); }

    try { req.setAttribute("itemCount", itemDao.countAll()); }
    catch (RuntimeException ex) { req.setAttribute("itemCount", 0); log("item count failed", ex); }

    // ADMIN numbers (already there)
    try {
      List<Bill> today = billingDao.getTodaySales();
      BigDecimal todaySum = today.stream()
          .map(b -> b.getTotal() == null ? BigDecimal.ZERO : b.getTotal())
          .reduce(BigDecimal.ZERO, BigDecimal::add);
      req.setAttribute("todaySales", todaySum); // admin.jsp use
    } catch (RuntimeException ex) {
      log("admin today sales failed", ex);
      req.setAttribute("todaySales", BigDecimal.ZERO);
    }

    // 👇 STAFF-specific: today sales of current staff user
    String staffUser = String.valueOf(s.getAttribute("user")); // login username
    try {
      List<Bill> myToday = billingDao.getTodaySalesByStaff(staffUser);
      BigDecimal myTodaySum = myToday.stream()
          .map(b -> b.getTotal() == null ? BigDecimal.ZERO : b.getTotal())
          .reduce(BigDecimal.ZERO, BigDecimal::add);
      req.setAttribute("staffTodaySales", myTodaySum);
    } catch (RuntimeException ex) {
      log("staff today sales failed", ex);
      req.setAttribute("staffTodaySales", BigDecimal.ZERO);
    }

    // (optional) legacy
    req.setAttribute("dailySummary", "");

    String role = (String) s.getAttribute("role");
    if ("ADMIN".equals(role)) {
      req.getRequestDispatcher("/views/dashboard/admin.jsp").forward(req, resp);
    } else {
      req.getRequestDispatcher("/views/dashboard/staff.jsp").forward(req, resp);
    }
  }
}
