// src/main/java/com/pahanaedu/web/ItemServlet.java
package com.pahanaedu.web;

import com.pahanaedu.model.Item;
import com.pahanaedu.service.ItemService;
import com.pahanaedu.service.impl.ItemServiceImpl;

// 🔽 add for logging
import com.pahanaedu.service.LogService;
import com.pahanaedu.service.impl.LogServiceImpl;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.*;
import java.math.BigDecimal;
import java.nio.file.Files;
import java.util.Optional;

@WebServlet("/items")
@MultipartConfig(maxFileSize = 5 * 1024 * 1024) // 5MB
public class ItemServlet extends HttpServlet {
    private final ItemService service = new ItemServiceImpl();
    private final LogService logService = new LogServiceImpl(); // logging

    // ---- helpers for upload ----
    private String saveImage(HttpServletRequest req, Part part) throws IOException {
        if (part == null || part.getSize() == 0) return null;

        String submitted = part.getSubmittedFileName();
        if (submitted == null || submitted.isBlank()) return null;

        String lower = submitted.toLowerCase();
        if (!(lower.endsWith(".png") || lower.endsWith(".jpg") || lower.endsWith(".jpeg") || lower.endsWith(".webp"))) {
            throw new IllegalArgumentException("Only PNG/JPG/JPEG/WEBP allowed");
        }

        String ext = lower.substring(lower.lastIndexOf('.')); // .png / .jpg ...
        String fileName = System.currentTimeMillis() + "-" + Math.abs(submitted.hashCode()) + ext;

        String relDir = "/images/items";
        String absDir = getServletContext().getRealPath(relDir);
        Files.createDirectories(new File(absDir).toPath());

        File out = new File(absDir, fileName);
        try (InputStream in = part.getInputStream(); OutputStream os = new FileOutputStream(out)) {
            in.transferTo(os);
        }
        return relDir + "/" + fileName; // save relative path
    }

    private void safeLog(HttpServletRequest req, String action, String refType, Long refId) {
        try { logService.log(req, action, refType, refId); } catch (Exception ignore) {}
    }

    private static Long parseId(String s) {
        try { return (s == null || s.isBlank()) ? null : Long.valueOf(s); }
        catch (NumberFormatException e) { return null; }
    }
    private static String t(String s){ return s==null? null : s.trim(); }
    private static boolean blank(String s){ return s==null || s.trim().isEmpty(); }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");

        try {
            if ("new".equalsIgnoreCase(action)) {
                req.getRequestDispatcher("/views/items/form.jsp").forward(req, resp);

            } else if ("edit".equalsIgnoreCase(action)) {
                Long id = parseId(req.getParameter("id"));
                if (id == null) { resp.sendError(400, "Missing/invalid id"); return; }
                Optional<Item> found = service.byId(id);
                if (found.isEmpty()) { resp.sendError(404, "Item not found"); return; }
                req.setAttribute("item", found.get());
                req.getRequestDispatcher("/views/items/form.jsp").forward(req, resp);

            } else if ("delete".equalsIgnoreCase(action)) {
                Long id = parseId(req.getParameter("id"));
                if (id == null) { resp.sendError(400, "Missing/invalid id"); return; }

                // (optional) remove old image file too
                String oldImg = service.byId(id).map(Item::getImage).orElse(null);

                service.delete(id);
                safeLog(req, "ITEM_DELETE", "ITEM", id);

                // optional: delete file from disk
                if (oldImg != null && !oldImg.isBlank()) {
                    try {
                        String absPath = getServletContext().getRealPath(oldImg);
                        if (absPath != null) new File(absPath).delete();
                    } catch (Exception ignore) {}
                }

                resp.sendRedirect(req.getContextPath() + "/items");

            } else {
                // SEARCH / FILTER
                String qName = t(req.getParameter("qName"));
                Long qId = parseId(req.getParameter("qId"));
                String qCat = t(req.getParameter("qCategory"));
                if ("ALL".equalsIgnoreCase(qCat)) qCat = null;

                if (qName != null || qId != null || qCat != null) {
                    req.setAttribute("items", service.search(qName, qId, qCat));
                } else {
                    req.setAttribute("items", service.all());
                }
                req.setAttribute("qName", qName);
                req.setAttribute("qId", (qId == null ? "" : qId.toString()));
                req.setAttribute("qCategory", (qCat == null ? "ALL" : qCat));

                req.getRequestDispatcher("/views/items/list.jsp").forward(req, resp);
            }
        } catch (Exception ex) {
            req.setAttribute("error", ex.getMessage());
            req.getRequestDispatcher("/views/items/list.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");

        String idStr = req.getParameter("id");
        String name  = t(req.getParameter("name"));
        String priceStr = t(req.getParameter("price"));
        String qtyStr   = t(req.getParameter("quantity"));
        String category = t(req.getParameter("category"));
        String description = t(req.getParameter("description"));

        Item i = new Item();
        i.setName(name);
        i.setCategory(category);
        i.setDescription(description);

        try {
            i.setPrice(new BigDecimal(priceStr));
            i.setQuantity(Integer.valueOf(qtyStr));

            Part img = req.getPart("imageFile");
            String newPath = saveImage(req, img);

            if (blank(idStr)) {
                if (newPath != null) i.setImage(newPath);
                service.create(i);              // expect service to set i.id

                // ✅ log create
                safeLog(req, "ITEM_CREATE", "ITEM", i.getId());

            } else {
                Long id = parseId(idStr);
                if (id == null) throw new IllegalArgumentException("Invalid id");
                i.setId(id);

                String existing = service.byId(id).map(Item::getImage).orElse(null);
                String finalPath = (newPath != null ? newPath : existing);
                i.setImage(finalPath);

                // (optional) if new image uploaded, delete old physical file
                if (newPath != null && existing != null && !existing.isBlank() && !existing.equals(newPath)) {
                    try {
                        String abs = getServletContext().getRealPath(existing);
                        if (abs != null) new File(abs).delete();
                    } catch (Exception ignore) {}
                }

                service.update(i);

                // ✅ log update
                safeLog(req, "ITEM_UPDATE", "ITEM", id);
            }
            resp.sendRedirect(req.getContextPath() + "/items");

        } catch (NumberFormatException nfe) {
            req.setAttribute("error", "Invalid number for price/quantity");
            req.setAttribute("item", i);
            req.getRequestDispatcher("/views/items/form.jsp").forward(req, resp);

        } catch (IllegalArgumentException ex) {
            req.setAttribute("error", ex.getMessage());
            req.setAttribute("item", i);
            req.getRequestDispatcher("/views/items/form.jsp").forward(req, resp);
        }
    }
}
