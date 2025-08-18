package com.pahanaedu.web;

import com.pahanaedu.dao.ItemDAO;
import com.pahanaedu.dao.impl.ItemDAOImpl;
import com.pahanaedu.dao.CustomerDAO;
import com.pahanaedu.dao.impl.CustomerDAOImpl;
import com.pahanaedu.model.Bill;
import com.pahanaedu.model.BillItem;
import com.pahanaedu.model.Item;
import com.pahanaedu.model.Customer;
import com.pahanaedu.service.BillingService;
import com.pahanaedu.service.impl.BillingServiceImpl;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.*;

@WebServlet("/billing")
public class BillingServlet extends HttpServlet {

    private final BillingService billing = new BillingServiceImpl();
    private final ItemDAO itemDAO = new ItemDAOImpl();
    private final CustomerDAO customerDAO = new CustomerDAOImpl();

    /* ----------------- helpers ----------------- */
    private void populateCatalog(HttpServletRequest req) {
        String q   = req.getParameter("q");
        String cat = req.getParameter("cat");
        if (cat == null || cat.isBlank()) cat = "ALL";

        List<String> cats = Arrays.asList("Textbooks","Stationery","Novels","Magazines","Others");
        req.setAttribute("categories", cats);
        req.setAttribute("q", q);
        req.setAttribute("cat", cat);

        // Fetch all; JSP side filters by q + cat (simple & fast enough for now)
        req.setAttribute("allItems", itemDAO.findAll());
    }

    @SuppressWarnings("unchecked")
    private List<BillItem> cart(HttpServletRequest req) {
        HttpSession s = req.getSession(true);
        Object o = s.getAttribute("cart");
        if (o == null) {
            List<BillItem> list = new ArrayList<>();
            s.setAttribute("cart", list);
            return list;
        }
        return (List<BillItem>) o;
    }

    private Bill draft(HttpServletRequest req) {
        HttpSession s = req.getSession(true);
        Bill b = (Bill) s.getAttribute("billDraft");
        if (b == null) {
            b = new Bill();
            Object u = s.getAttribute("user");
            b.setStaffUser(u == null ? "unknown" : u.toString());
            b.setItems(cart(req));
            b.setDiscountPercent(BigDecimal.ZERO);
            billing.recompute(b);
            s.setAttribute("billDraft", b);
        }
        return b;
    }

    private static Long parseId(String s) {
        try { return (s == null || s.isBlank()) ? null : Long.valueOf(s); }
        catch (NumberFormatException e) { return null; }
    }
    private static Integer parseInt(String s) {
        try { return (s == null || s.isBlank()) ? null : Integer.valueOf(s); }
        catch (NumberFormatException e) { return null; }
    }
    private static BigDecimal parseDecimal(String s) {
        try { return (s == null || s.isBlank()) ? null : new BigDecimal(s); }
        catch (NumberFormatException e) { return null; }
    }
    /* ------------------------------------------- */

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");
        populateCatalog(req);
        List<BillItem> cart = cart(req);
        Bill bill = draft(req);

        try {
            if ("remove".equalsIgnoreCase(action)) {
                Long itemId = parseId(req.getParameter("itemId"));
                if (itemId != null) {
                    cart.removeIf(bi -> itemId.equals(bi.getItemId()));
                }
                billing.recompute(bill);
            } else if ("clear".equalsIgnoreCase(action)) {
                cart.clear();
                billing.recompute(bill);
            }
            req.getRequestDispatcher("/views/billing/form.jsp").forward(req, resp);

        } catch (Exception ex) {
            req.setAttribute("error", ex.getMessage());
            req.getRequestDispatcher("/views/billing/form.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        String action = req.getParameter("action");
        List<BillItem> cart = cart(req);
        Bill bill = draft(req);

        try {
            if ("add".equalsIgnoreCase(action)) {
                Long itemId = parseId(req.getParameter("itemId"));
                Integer qty  = parseInt(req.getParameter("qty"));
                if (itemId == null || qty == null || qty <= 0)
                    throw new IllegalArgumentException("Valid item id and quantity required");

                Item item = itemDAO.findById(itemId)
                        .orElseThrow(() -> new IllegalArgumentException("Item not found"));

                BillItem existing = null;
                for (BillItem bi : cart) if (bi.getItemId().equals(itemId)) { existing = bi; break; }

                if (existing == null) {
                    BillItem bi = new BillItem();
                    bi.setItemId(item.getId());
                    bi.setItemName(item.getName());
                    bi.setUnitPrice(item.getPrice());
                    bi.setQuantity(qty);
                    cart.add(bi);
                } else {
                    existing.setQuantity(existing.getQuantity() + qty);
                }
                billing.recompute(bill);

            } else if ("inc".equalsIgnoreCase(action) || "dec".equalsIgnoreCase(action)) {
                Long itemId = parseId(req.getParameter("itemId"));
                for (BillItem bi : cart) {
                    if (bi.getItemId().equals(itemId)) {
                        int q = bi.getQuantity() == null ? 0 : bi.getQuantity();
                        bi.setQuantity("inc".equalsIgnoreCase(action) ? q + 1 : Math.max(0, q - 1));
                        break;
                    }
                }
                cart.removeIf(bi -> bi.getQuantity() == 0);
                billing.recompute(bill);

            } else if ("updateQty".equalsIgnoreCase(action)) {
                Long itemId = parseId(req.getParameter("itemId"));
                Integer qty = parseInt(req.getParameter("qty"));
                for (BillItem bi : cart) {
                    if (bi.getItemId().equals(itemId)) {
                        bi.setQuantity(qty == null ? 0 : Math.max(0, qty));
                        break;
                    }
                }
                cart.removeIf(bi -> bi.getQuantity() == 0);
                billing.recompute(bill);

            } else if ("discount".equalsIgnoreCase(action)) {
                BigDecimal d = parseDecimal(req.getParameter("discountPercent"));
                bill.setDiscountPercent(d == null ? BigDecimal.ZERO : d);
                billing.recompute(bill);

            } else if ("discountClear".equalsIgnoreCase(action)) {
                bill.setDiscountPercent(BigDecimal.ZERO);
                billing.recompute(bill);

            } else if ("setCustomer".equalsIgnoreCase(action)) {
                // one-box lookup: ID / PE-ACC-xxxxx / phone
                String key = req.getParameter("customerKey");
                Optional<Customer> oc = Optional.empty();

                if (key != null && key.matches("\\d+")) {
                    oc = customerDAO.findById(Long.valueOf(key));
                }
                if (oc.isEmpty() && key != null && key.toUpperCase().startsWith("PE-ACC-")) {
                    oc = customerDAO.findByAccount(key.trim());
                }
                if (oc.isEmpty() && key != null) {
                    oc = customerDAO.findByPhone(key.trim());
                }

                if (oc.isPresent()) {
                    Customer c = oc.get();
                    bill.setCustomerId(c.getId());
                    req.getSession().setAttribute("billCustomerName", c.getName());
                    req.getSession().setAttribute("billCustomerObj", c);
                } else {
                    req.setAttribute("error", "Customer not found");
                    bill.setCustomerId(null);
                    req.getSession().removeAttribute("billCustomerName");
                    req.getSession().removeAttribute("billCustomerObj");
                }

            } else if ("clearCustomer".equalsIgnoreCase(action)) {
                bill.setCustomerId(null);
                req.getSession().removeAttribute("billCustomerName");
                req.getSession().removeAttribute("billCustomerObj");

            } else if ("save".equalsIgnoreCase(action)) {
                if (cart.isEmpty()) throw new IllegalArgumentException("Cart is empty");
                Object u = req.getSession().getAttribute("user");
                bill.setStaffUser(u == null ? "unknown" : u.toString());
                billing.recompute(bill);

                Long billId = billing.save(bill, cart);

                // pass to receipt + clear session
                req.setAttribute("billId", billId);
                req.setAttribute("savedBill", bill);
                req.setAttribute("savedItems", new ArrayList<>(cart));
                Object custObj = req.getSession().getAttribute("billCustomerObj");
                if (custObj != null) req.setAttribute("savedCustomer", custObj);

                req.getSession().removeAttribute("cart");
                req.getSession().removeAttribute("billDraft");
                req.getSession().removeAttribute("billCustomerName");
                req.getSession().removeAttribute("billCustomerObj");

                req.getRequestDispatcher("/views/billing/receipt.jsp").forward(req, resp);
                return; // already forwarded
            }

            populateCatalog(req);
            req.getRequestDispatcher("/views/billing/form.jsp").forward(req, resp);

        } catch (IllegalArgumentException ex) {
            req.setAttribute("error", ex.getMessage());
            populateCatalog(req);
            req.getRequestDispatcher("/views/billing/form.jsp").forward(req, resp);
        }
    }
}
