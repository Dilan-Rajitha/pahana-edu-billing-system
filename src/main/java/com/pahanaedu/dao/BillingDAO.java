package com.pahanaedu.dao;

import com.pahanaedu.model.Bill;
import com.pahanaedu.model.BillItem;
import java.util.List;
import java.util.Optional;

public interface BillingDAO {
    Long saveBill(Bill bill, List<BillItem> items);

    Optional<Bill> findBill(Long id);
    List<BillItem> findBillItems(Long billId);
        
    // New For reports
    List<Bill> getTodaySales();
    List<Bill> getLast7DaysSales();
    List<Bill> getLast30DaysSales();
    List<Bill> getAllTimeSales();
    
    
    // today sales filtered by staff username
    List<Bill> getTodaySalesByStaff(String staffUser);
}
