//package com.pahanaedu.dao;
//
//import com.pahanaedu.model.Bill;
//import com.pahanaedu.model.BillItem;
//
//import java.util.List;
//
//public interface BillingDAO {
//    Long saveBill(Bill bill, List<BillItem> items); 
//}

package com.pahanaedu.dao;

import com.pahanaedu.model.Bill;
import com.pahanaedu.model.BillItem;
import java.util.List;
import java.util.Optional;

public interface BillingDAO {
    Long saveBill(Bill bill, List<BillItem> items);

    Optional<Bill> findBill(Long id);
    List<BillItem> findBillItems(Long billId);
    
  
    List<Bill> getTodaySales();
    List<Bill> getLast7DaysSales();
    List<Bill> getLast30DaysSales();
    List<Bill> getAllTimeSales();
    
    
    List<Bill> getTodaySalesByStaff(String staffUser);
}
