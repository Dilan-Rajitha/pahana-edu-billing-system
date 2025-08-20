package com.pahanaedu.dao.impl;

import com.pahanaedu.dao.BillingDAO;
import com.pahanaedu.model.Bill;
import com.pahanaedu.model.BillItem;
import com.pahanaedu.util.ConnectionFactory;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class BillingDAOImpl implements BillingDAO {
    private final ConnectionFactory cf = ConnectionFactory.getInstance();

    @Override
    public Long saveBill(Bill bill, List<BillItem> items) {
        String sqlBill = "INSERT INTO bills(customer_id, staff_user, subtotal, discount_percent, total) VALUES(?,?,?,?,?)";
        String sqlItem = "INSERT INTO bill_items(bill_id, item_id, unit_price, quantity, subtotal) VALUES(?,?,?,?,?)";

        try (Connection con = cf.getConnection()) {
            con.setAutoCommit(false);
            Long billId;

            try (PreparedStatement ps = con.prepareStatement(sqlBill, Statement.RETURN_GENERATED_KEYS)) {
                if (bill.getCustomerId() == null) ps.setNull(1, Types.BIGINT); else ps.setLong(1, bill.getCustomerId());
                ps.setString(2, bill.getStaffUser());
                ps.setBigDecimal(3, bill.getSubtotal());
                ps.setBigDecimal(4, bill.getDiscountPercent());
                ps.setBigDecimal(5, bill.getTotal());
                ps.executeUpdate();
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    rs.next();
                    billId = rs.getLong(1);
                }
            }

            try (PreparedStatement ps = con.prepareStatement(sqlItem)) {
                for (BillItem bi : items) {
                    ps.setLong(1, billId);
                    ps.setLong(2, bi.getItemId());
                    ps.setBigDecimal(3, bi.getUnitPrice());
                    ps.setInt(4, bi.getQuantity());
                    ps.setBigDecimal(5, bi.getSubtotal());
                    ps.addBatch();
                }
                ps.executeBatch();
            }

            con.commit();
            return billId;
        } catch (Exception e) {
            throw new RuntimeException("Saving bill failed", e);
        }
    }
    
    @Override
    public Optional<Bill> findBill(Long id) {
        String sql = "SELECT id, customer_id, staff_user, subtotal, discount_percent, total, created_at " +
                     "FROM bills WHERE id=?";
        try (Connection con = cf.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setLong(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Bill b = new Bill();
                    b.setId(rs.getLong("id"));
                    long cid = rs.getLong("customer_id");
                    b.setCustomerId(rs.wasNull()? null : cid);
                    b.setStaffUser(rs.getString("staff_user"));
                    b.setSubtotal(rs.getBigDecimal("subtotal"));
                    b.setDiscountPercent(rs.getBigDecimal("discount_percent"));
                    b.setTotal(rs.getBigDecimal("total"));
                    b.setCreatedAt(rs.getTimestamp("created_at"));
                    return Optional.of(b);
                }
            }
            return Optional.empty();
        } catch (Exception e) { 
            System.err.println("Error finding bill: " + e.getMessage());
            throw new RuntimeException(e); 
        }
    }

    @Override
    public List<BillItem> findBillItems(Long billId) {
        String sql = "SELECT bi.id, bi.item_id, i.name, bi.unit_price, bi.quantity, bi.subtotal " +
                     "FROM bill_items bi JOIN items i ON i.id=bi.item_id WHERE bi.bill_id=?";
        List<BillItem> list = new ArrayList<>();
        try (Connection con = cf.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setLong(1, billId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    BillItem bi = new BillItem();
                    bi.setId(rs.getLong("id"));
                    bi.setBillId(billId);
                    bi.setItemId(rs.getLong("item_id"));
                    bi.setItemName(rs.getString("name"));
                    bi.setUnitPrice(rs.getBigDecimal("unit_price"));
                    bi.setQuantity(rs.getInt("quantity"));
                    bi.setSubtotal(rs.getBigDecimal("subtotal"));
                    list.add(bi);
                }
            }
        } catch (Exception e) { 
            System.err.println("Error finding bill items: " + e.getMessage());
            throw new RuntimeException(e); 
        }
        return list;
    }
    
    // Report methods
    @Override
    public List<Bill> getTodaySales() {
        String sql = "SELECT * FROM bills WHERE DATE(created_at) = CURDATE() ORDER BY created_at DESC";
        System.out.println("Executing query: " + sql);
        return getSalesData(sql, "today's sales");
    }

    @Override
    public List<Bill> getLast7DaysSales() {
        String sql = "SELECT * FROM bills WHERE created_at >= NOW() - INTERVAL 7 DAY ORDER BY created_at DESC";
        System.out.println("Executing query: " + sql);
        return getSalesData(sql, "last 7 days sales");
    }

    @Override
    public List<Bill> getLast30DaysSales() {
        String sql = "SELECT * FROM bills WHERE created_at >= NOW() - INTERVAL 30 DAY ORDER BY created_at DESC";
        System.out.println("Executing query: " + sql);
        return getSalesData(sql, "last 30 days sales");
    }

    @Override
    public List<Bill> getAllTimeSales() {
        String sql = "SELECT * FROM bills ORDER BY created_at DESC";
        System.out.println("Executing query: " + sql);
        return getSalesData(sql, "all time sales");
    }

    private List<Bill> getSalesData(String sql, String description) {
        List<Bill> sales = new ArrayList<>();
        try (Connection con = cf.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            System.out.println("Fetching " + description + "...");
            
            while (rs.next()) {
                Bill bill = new Bill();
                bill.setId(rs.getLong("id"));
                
                
                long customerId = rs.getLong("customer_id");
                if (!rs.wasNull()) {
                    bill.setCustomerId(customerId);
                }
                
                bill.setStaffUser(rs.getString("staff_user"));
                bill.setSubtotal(rs.getBigDecimal("subtotal"));
                bill.setDiscountPercent(rs.getBigDecimal("discount_percent"));
                bill.setTotal(rs.getBigDecimal("total"));
                bill.setCreatedAt(rs.getTimestamp("created_at"));
                
                sales.add(bill);
            }
            
            System.out.println("Successfully fetched " + sales.size() + " records for " + description);
            
        } catch (SQLException e) {
            System.err.println("Database error while fetching " + description + ": " + e.getMessage());
            e.printStackTrace();
            
        } catch (Exception e) {
            System.err.println("Unexpected error while fetching " + description + ": " + e.getMessage());
            e.printStackTrace();
            
        }
        
        return sales;
    }
    
    
    
    // for staff
    @Override
    public List<Bill> getTodaySalesByStaff(String staffUser) {
        String sql = "SELECT * FROM bills WHERE DATE(created_at)=CURDATE() AND staff_user=? ORDER BY created_at DESC";
        List<Bill> list = new ArrayList<>();
        try (Connection con = cf.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, staffUser);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Bill b = new Bill();
                    b.setId(rs.getLong("id"));
                    long cid = rs.getLong("customer_id");
                    if (!rs.wasNull()) b.setCustomerId(cid);
                    b.setStaffUser(rs.getString("staff_user"));
                    b.setSubtotal(rs.getBigDecimal("subtotal"));
                    b.setDiscountPercent(rs.getBigDecimal("discount_percent"));
                    b.setTotal(rs.getBigDecimal("total"));
                    b.setCreatedAt(rs.getTimestamp("created_at"));
                    list.add(b);
                }
            }
        } catch (Exception e) {
            System.err.println("Error getTodaySalesByStaff: " + e.getMessage());
        }
        return list;
    }

}