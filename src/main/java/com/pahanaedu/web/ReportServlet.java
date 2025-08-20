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
            //date range 
            String dateRange = req.getParameter("dateRange");
            if (dateRange == null || dateRange.trim().isEmpty()) {
                dateRange = "allTime";
            }
            
            System.out.println("Processing report request for dateRange: " + dateRange);
            
            // Generate report data
            List<Bill> reportData = reportService.generateReport(dateRange);
            System.out.println("Retrieved " + reportData.size() + " bills for report");
            
           
            Gson gson = new GsonBuilder()
                    .setDateFormat("MMM dd, yyyy, hh:mm:ss a") 
                    .create();
            
            String jsonReportData = gson.toJson(reportData);
            System.out.println("Generated JSON data: " + jsonReportData);
            
            
            req.setAttribute("jsonReportData", jsonReportData);
            req.setAttribute("selectedDateRange", dateRange);
            req.setAttribute("recordCount", reportData.size());
            
           
            req.getRequestDispatcher("/views/reports/report.jsp").forward(req, resp);
            
        } catch (Exception e) {
            System.err.println("Error in ReportServlet: " + e.getMessage());
            e.printStackTrace();
            
            
            req.setAttribute("jsonReportData", "[]"); 
            req.setAttribute("error", "Error generating report: " + e.getMessage());
            req.setAttribute("selectedDateRange", req.getParameter("dateRange"));
            req.setAttribute("recordCount", 0);
            
            
            req.getRequestDispatcher("/views/reports/report.jsp").forward(req, resp);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        
        String action = req.getServletPath();
        if (action.endsWith("/export")) {
           
            resp.getWriter().write("PDF Export not yet implemented");
        } else {
            doGet(req, resp);
        }
    }
}