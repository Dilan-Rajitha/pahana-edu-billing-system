package com.pahanaedu.web;

import com.itextpdf.text.*;
import com.itextpdf.text.pdf.*;
import com.pahanaedu.model.Bill;
import com.pahanaedu.service.ReportService;
import com.pahanaedu.service.impl.ReportServiceImpl;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.io.OutputStream;
import java.util.List;

@WebServlet("/reports/export")
public class ReportExportServlet extends HttpServlet {

    private final ReportService reportService = new ReportServiceImpl();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String dateRange = req.getParameter("dateRange");
        if(dateRange == null) dateRange = "all"; // default

        List<Bill> reportData = reportService.generateReport(dateRange);

        resp.setContentType("application/pdf");
        resp.setHeader("Content-Disposition", "attachment; filename=\"SalesReport.pdf\"");

        try {
            Document document = new Document(PageSize.A4.rotate());
            OutputStream os = resp.getOutputStream();
            PdfWriter.getInstance(document, os);
            document.open();

            Font fontTitle = new Font(Font.FontFamily.HELVETICA, 16, Font.BOLD);
            Paragraph title = new Paragraph("Sales Report", fontTitle);
            title.setAlignment(Element.ALIGN_CENTER);
            title.setSpacingAfter(20);
            document.add(title);

            PdfPTable table = new PdfPTable(8); // 8 columns
            table.setWidthPercentage(100);
            table.setWidths(new int[]{2,2,3,2,2,2,2,3});

            // Table header
            String[] headers = {"Bill ID","Customer ID","Staff User","Subtotal","Discount (%)","Discount Amount","Total","Created At"};
            for(String h: headers){
                PdfPCell cell = new PdfPCell(new Phrase(h));
                cell.setBackgroundColor(BaseColor.LIGHT_GRAY);
                cell.setHorizontalAlignment(Element.ALIGN_CENTER);
                table.addCell(cell);
            }

            // Table data
            for(Bill b: reportData){
                double discAmt = b.getSubtotal().doubleValue() * b.getDiscountPercent().doubleValue()/100.0;

                table.addCell(String.valueOf(b.getId()));
                table.addCell(b.getCustomerId() == null ? "Walk-in" : String.valueOf(b.getCustomerId()));
                table.addCell(b.getStaffUser());
                table.addCell(String.format("Rs. %.2f", b.getSubtotal()));
                table.addCell(String.format("%.1f%%", b.getDiscountPercent()));
                table.addCell(String.format("Rs. %.2f", discAmt));
                table.addCell(String.format("Rs. %.2f", b.getTotal()));
                table.addCell(String.valueOf(b.getCreatedAt()));
            }

            document.add(table);
            document.close();
        } catch (Exception e){
            throw new ServletException("PDF generation failed", e);
        }
    }
}
