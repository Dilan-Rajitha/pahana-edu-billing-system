package com.pahanaedu.web;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.pahanaedu.dao.impl.BillingDAOImpl;
import com.pahanaedu.dao.BillingDAO;
import com.pahanaedu.model.Bill;
import com.pahanaedu.service.ReportService;
import com.pahanaedu.service.impl.ReportServiceImpl;

import java.io.IOException;
import java.util.List;
import java.text.SimpleDateFormat;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/reports")
public class ReportServlet extends HttpServlet {
    private final ReportService reportService = new ReportServiceImpl();
    private final BillingDAO billDAO = new BillingDAOImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        
        try {
            // Get date range parameter
            String dateRange = req.getParameter("dateRange");
            if (dateRange == null || dateRange.trim().isEmpty()) {
                dateRange = "allTime"; // Default value
            }
            
            System.out.println("Processing report request for dateRange: " + dateRange);
            
            // Generate report data
            List<Bill> reportData = reportService.generateReport(dateRange);
            System.out.println("Retrieved " + reportData.size() + " bills for report");
            
            // Create Gson with custom date format to handle Timestamp properly
            Gson gson = new GsonBuilder()
                    .setDateFormat("MMM dd, yyyy, hh:mm:ss a") // Format to match your existing format
                    .create();
            
            String jsonReportData = gson.toJson(reportData);
            System.out.println("Generated JSON data: " + jsonReportData);
            
            // Set attributes for JSP
            req.setAttribute("jsonReportData", jsonReportData);
            req.setAttribute("selectedDateRange", dateRange);
            req.setAttribute("recordCount", reportData.size());
            
            // Forward to JSP
            req.getRequestDispatcher("/views/reports/report.jsp").forward(req, resp);
            
        } catch (Exception e) {
            System.err.println("Error in ReportServlet: " + e.getMessage());
            e.printStackTrace();
            
            // Set error attributes
            req.setAttribute("jsonReportData", "[]"); // Empty JSON array
            req.setAttribute("error", "Error generating report: " + e.getMessage());
            req.setAttribute("selectedDateRange", req.getParameter("dateRange"));
            req.setAttribute("recordCount", 0);
            
            // Still forward to JSP to show error message
            req.getRequestDispatcher("/views/reports/report.jsp").forward(req, resp);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        // Handle PDF export or other POST requests
        String action = req.getServletPath();
        if (action.endsWith("/export")) {
            // TODO: Implement PDF export functionality
            resp.getWriter().write("PDF Export not yet implemented");
        } else {
            doGet(req, resp);
        }
    }
}