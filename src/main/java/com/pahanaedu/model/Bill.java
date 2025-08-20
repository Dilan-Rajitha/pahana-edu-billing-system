package com.pahanaedu.model;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

import java.sql.Timestamp;  

public class Bill {
    private Long id;
    private Long customerId;   
    private String staffUser;    
    private BigDecimal subtotal = BigDecimal.ZERO;
    private BigDecimal discountPercent = BigDecimal.ZERO; 
    private BigDecimal total = BigDecimal.ZERO;
    private List<BillItem> items = new ArrayList<>();
    
    

    private Timestamp createdAt;

    public Long getId() { return id; }
    
    public void setId(Long id) { this.id = id; }
    
    public Long getCustomerId() { return customerId; }
    
    public void setCustomerId(Long customerId) { this.customerId = customerId; }
    
    public String getStaffUser() { return staffUser; }
    
    public void setStaffUser(String staffUser) { this.staffUser = staffUser; }
    
    public BigDecimal getSubtotal() { return subtotal; }
    
    public void setSubtotal(BigDecimal subtotal) { this.subtotal = subtotal; }
    
    public BigDecimal getDiscountPercent() { return discountPercent; }
    
    public void setDiscountPercent(BigDecimal discountPercent) { this.discountPercent = discountPercent; }
    
    public BigDecimal getTotal() { return total; }
    
    public void setTotal(BigDecimal total) { this.total = total; }
    
    public List<BillItem> getItems() { return items; }
    
    public void setItems(List<BillItem> items) { this.items = items; }
    
    
    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
}
