package com.pahanaedu.service;

import com.pahanaedu.model.Bill;
import com.pahanaedu.model.BillItem;

import java.math.BigDecimal;
import java.util.List;

public interface BillingService {
    // recompute subtotal/total on the bill (mutates bill)
    void recompute(Bill bill);

    // persist
    Long save(Bill bill, List<BillItem> items);

    // helpers
    BigDecimal calcItemSubtotal(BillItem bi);
}
