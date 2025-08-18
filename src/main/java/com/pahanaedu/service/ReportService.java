package com.pahanaedu.service;

import com.pahanaedu.model.Bill;

import java.util.List;

public interface ReportService {
    List<Bill> generateReport(String period);
}
