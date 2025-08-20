package com.pahanaedu.web;

import com.pahanaedu.model.Customer;
import com.pahanaedu.service.CustomerService;
import com.pahanaedu.service.impl.CustomerServiceImpl;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;
import java.util.Optional;

@WebServlet("/customers")
public class CustomerServlet extends HttpServlet {
    private final CustomerService service = new CustomerServiceImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");

        try {
            if ("new".equalsIgnoreCase(action)) {
                req.setAttribute("nextAcc", service.nextAccountNumber());
                req.getRequestDispatcher("/views/customers/form.jsp").forward(req, resp);

            } else if ("edit".equalsIgnoreCase(action)) {
                Long id = parseId(req.getParameter("id"));
                if (id == null) { resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing/invalid id"); return; }
                Optional<Customer> found = service.byId(id);
                if (found.isEmpty()) { resp.sendError(HttpServletResponse.SC_NOT_FOUND, "Customer not found"); return; }
                req.setAttribute("customer", found.get());
                req.getRequestDispatcher("/views/customers/form.jsp").forward(req, resp);

            } else if ("delete".equalsIgnoreCase(action)) {
                Long id = parseId(req.getParameter("id"));
                if (id == null) { resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing/invalid id"); return; }
                service.delete(id);
                resp.sendRedirect(req.getContextPath() + "/customers");

            } else {
                
                String q = trim(req.getParameter("q"));
                List<Customer> list = (q != null && !q.isBlank())
                        ? service.search(q)   
                        : service.all();

                req.setAttribute("q", q);
                req.setAttribute("customers", list);
                req.getRequestDispatcher("/views/customers/list.jsp").forward(req, resp);
            }

        } catch (Exception ex) {
    
            req.setAttribute("error", ex.getMessage());
            req.setAttribute("customers", service.all());
            req.getRequestDispatcher("/views/customers/list.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");

        String idStr   = req.getParameter("id");
        String account = trim(req.getParameter("accountNumber"));
        String name    = trim(req.getParameter("name"));
        String address = trim(req.getParameter("address"));
        String phone   = trim(req.getParameter("phone"));
        String email   = trim(req.getParameter("email"));

        Customer c = new Customer();
        c.setAccountNumber(account);
        c.setName(name);
        c.setAddress(address);
        c.setPhone(phone);
        c.setEmail(email);

        try {
            if (isBlank(idStr)) {
               
                service.register(c); 
            } else {
                
                Long id = parseId(idStr);
                if (id == null) throw new IllegalArgumentException("Invalid id.");
                c.setId(id);
                service.update(c);
            }
            resp.sendRedirect(req.getContextPath() + "/customers");

        } catch (IllegalArgumentException ex) {
            
            req.setAttribute("error", ex.getMessage());
            req.setAttribute("customer", c);

            if (isBlank(idStr)) {
                
                req.setAttribute("nextAcc", (isBlank(account) ? service.nextAccountNumber() : account));
            }
            req.getRequestDispatcher("/views/customers/form.jsp").forward(req, resp);
        }
    }

    private static Long parseId(String s) {
        try { return (s == null || s.isBlank()) ? null : Long.valueOf(s); }
        catch (NumberFormatException e) { return null; }
    }
    private static String trim(String s) { return s == null ? null : s.trim(); }
    private static boolean isBlank(String s) { return s == null || s.trim().isEmpty(); }
}
