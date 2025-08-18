package com.pahanaedu.service.impl;

import com.pahanaedu.dao.BillingDAO;
import com.pahanaedu.dao.impl.BillingDAOImpl;
import com.pahanaedu.model.Bill;
import com.pahanaedu.model.BillItem;
import com.pahanaedu.service.BillingService;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.List;

public class BillingServiceImpl implements BillingService {
    private final BillingDAO dao = new BillingDAOImpl();

    @Override
    public void recompute(Bill bill) {
        BigDecimal sub = BigDecimal.ZERO;
        if (bill.getItems() != null) {
            for (BillItem bi : bill.getItems()) {
                BigDecimal s = calcItemSubtotal(bi);
                bi.setSubtotal(s);
                sub = sub.add(s);
            }
        }
        bill.setSubtotal(sub.setScale(2, RoundingMode.HALF_UP));
        BigDecimal discount = bill.getDiscountPercent() == null ? BigDecimal.ZERO : bill.getDiscountPercent();
        if (discount.compareTo(BigDecimal.ZERO) < 0) discount = BigDecimal.ZERO;
        if (discount.compareTo(new BigDecimal("100")) > 0) discount = new BigDecimal("100");
        bill.setDiscountPercent(discount.setScale(2, RoundingMode.HALF_UP));

        BigDecimal discAmt = sub.multiply(discount).divide(new BigDecimal("100"), 2, RoundingMode.HALF_UP);
        BigDecimal total = sub.subtract(discAmt);
        bill.setTotal(total.setScale(2, RoundingMode.HALF_UP));
    }

    @Override
    public Long save(Bill bill, List<BillItem> items) {
        return dao.saveBill(bill, items);
    }

    @Override
    public BigDecimal calcItemSubtotal(BillItem bi) {
        BigDecimal price = bi.getUnitPrice() == null ? BigDecimal.ZERO : bi.getUnitPrice();
        int qty = bi.getQuantity() == null ? 0 : bi.getQuantity();
        return price.multiply(BigDecimal.valueOf(qty)).setScale(2, RoundingMode.HALF_UP);
    }
}
