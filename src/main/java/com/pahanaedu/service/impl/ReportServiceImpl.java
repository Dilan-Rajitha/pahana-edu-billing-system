package com.pahanaedu.service.impl;

import com.pahanaedu.dao.BillingDAO;
import com.pahanaedu.dao.impl.BillingDAOImpl;
import com.pahanaedu.model.Bill;
import com.pahanaedu.service.ReportService;

import java.util.ArrayList;
import java.util.List;

public class ReportServiceImpl implements ReportService {
    private final BillingDAO billDAO = new BillingDAOImpl();

    @Override
    public List<Bill> generateReport(String period) {
        // Handle null period gracefully
        if (period == null || period.trim().isEmpty()) {
            period = "allTime"; // Default to all time
        }

        List<Bill> reportData = new ArrayList<>();
        
        try {
            switch (period.toLowerCase()) {
                case "today":
                    System.out.println("Fetching today's sales...");
                    reportData = billDAO.getTodaySales();
                    break;
                case "last7":
                    System.out.println("Fetching last 7 days sales...");
                    reportData = billDAO.getLast7DaysSales();
                    break;
                case "last30":
                    System.out.println("Fetching last 30 days sales...");
                    reportData = billDAO.getLast30DaysSales();
                    break;
                case "alltime":  // Changed from "all" to "alltime" to match JSP
                case "all":      // Keep backward compatibility
                    System.out.println("Fetching all time sales...");
                    reportData = billDAO.getAllTimeSales();
                    break;
                default:
                    System.out.println("Unknown period '" + period + "', defaulting to all time sales...");
                    reportData = billDAO.getAllTimeSales();
            }
            
            System.out.println("Successfully retrieved " + reportData.size() + " records for period: " + period);
            return reportData;
            
        } catch (Exception e) {
            System.err.println("Error generating report for period: " + period);
            e.printStackTrace();
            // Return empty list instead of throwing exception
            return new ArrayList<>();
        }
    }
}