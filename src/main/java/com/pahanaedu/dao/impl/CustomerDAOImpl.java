package com.pahanaedu.dao.impl;

import com.pahanaedu.dao.CustomerDAO;
import com.pahanaedu.model.Customer;
import com.pahanaedu.util.ConnectionFactory;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class CustomerDAOImpl implements CustomerDAO {
    private final ConnectionFactory cf = ConnectionFactory.getInstance();

    @Override
    public Customer save(Customer c) {
        String sql = "INSERT INTO customers(account_number,name,address,phone,email) VALUES(?,?,?,?,?)";
        try (Connection con = cf.getConnection();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, c.getAccountNumber());
            ps.setString(2, c.getName());
            ps.setString(3, c.getAddress());
            ps.setString(4, c.getPhone());
            ps.setString(5, c.getEmail());
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) c.setId(rs.getLong(1));
            }
            return c;
        } catch (SQLException e) {
            throw new RuntimeException("Customer save failed", e);
        }
    }

    @Override
    public boolean update(Customer c) {
        String sql = "UPDATE customers SET name=?,address=?,phone=?,email=? WHERE id=?";
        try (Connection con = cf.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, c.getName());
            ps.setString(2, c.getAddress());
            ps.setString(3, c.getPhone());
            ps.setString(4, c.getEmail());
            ps.setLong(5, c.getId());
            return ps.executeUpdate() == 1;
        } catch (SQLException e) {
            throw new RuntimeException("Customer update failed", e);
        }
    }

    @Override
    public boolean deleteById(Long id) {
        String sql = "DELETE FROM customers WHERE id=?";
        try (Connection con = cf.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setLong(1, id);
            return ps.executeUpdate() == 1;
        } catch (SQLException e) {
            throw new RuntimeException("Customer delete failed", e);
        }
    }

    @Override
    public Optional<Customer> findById(Long id) {
        String sql = "SELECT * FROM customers WHERE id=?";
        try (Connection con = cf.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setLong(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return Optional.of(map(rs));
                return Optional.empty();
            }
        } catch (SQLException e) {
            throw new RuntimeException("findById failed", e);
        }
    }

    @Override
    public Optional<Customer> findByAccount(String acc) {
        String sql = "SELECT * FROM customers WHERE account_number=?";
        try (Connection con = cf.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, acc);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return Optional.of(map(rs));
                return Optional.empty();
            }
        } catch (SQLException e) {
            throw new RuntimeException("findByAccount failed", e);
        }
    }

    @Override
    public Optional<Customer> findByPhone(String phone) {
        String sql = "SELECT * FROM customers WHERE phone=?";
        try (Connection con = cf.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, phone);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return Optional.of(map(rs));
                return Optional.empty();
            }
        } catch (SQLException e) {
            throw new RuntimeException("findByPhone failed", e);
        }
    }

    @Override
    public List<Customer> findAll() {
        List<Customer> list = new ArrayList<>();
        String sql = "SELECT * FROM customers ORDER BY id DESC";
        try (Connection con = cf.getConnection();
             Statement st = con.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) list.add(map(rs));
            return list;
        } catch (SQLException e) {
            throw new RuntimeException("findAll failed", e);
        }
    }

    @Override
    public Integer findMaxAccountSuffix() {
        // PE-ACC
        String sql = "SELECT MAX(CAST(SUBSTRING(account_number, 8) AS UNSIGNED)) AS max_suf " +
                     "FROM customers WHERE account_number LIKE 'PE-ACC-%'";
        try (Connection con = cf.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                int v = rs.getInt("max_suf");
                return rs.wasNull() ? null : v;
            }
            return null;
        } catch (SQLException e) {
            throw new RuntimeException("findMaxAccountSuffix failed", e);
        }
    }

    private Customer map(ResultSet rs) throws SQLException {
        Customer c = new Customer();
        c.setId(rs.getLong("id"));
        c.setAccountNumber(rs.getString("account_number"));
        c.setName(rs.getString("name"));
        c.setAddress(rs.getString("address"));
        c.setPhone(rs.getString("phone"));
        c.setEmail(rs.getString("email"));
        return c;
    }
    
    
    //count
    @Override
    public int countAll() {
        String sql = "SELECT COUNT(*) FROM customers";
        try (Connection con = cf.getConnection();
             Statement st = con.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            rs.next();
            return rs.getInt(1);
        } catch (SQLException e) {
            throw new RuntimeException("Customer countAll failed", e);
        }
    }
    
    
    //customer search
    @Override
    public List<Customer> search(String keyword) {
        if (keyword == null || keyword.isBlank()) {
            return findAll();
        }

        String kw = "%" + keyword.trim().toLowerCase() + "%";
        List<Customer> list = new ArrayList<>();

        String sql = "SELECT * FROM customers " +
                     "WHERE LOWER(account_number) LIKE ? " +
                     "OR LOWER(phone) LIKE ? " +
                     "OR LOWER(name) LIKE ? " +
                     "OR CAST(id AS CHAR) LIKE ? " +
                     "ORDER BY id DESC";

        try (Connection con = cf.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, kw);
            ps.setString(2, kw);
            ps.setString(3, kw);
            ps.setString(4, kw);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(map(rs));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Customer search failed", e);
        }
        return list;
    }


}
