package com.pahanaedu.service;

import com.pahanaedu.model.Bill;
import com.pahanaedu.model.BillItem;

import java.math.BigDecimal;
import java.util.List;

public interface BillingService {

    void recompute(Bill bill);


    Long save(Bill bill, List<BillItem> items);


    BigDecimal calcItemSubtotal(BillItem bi);
    
}
