package com.pahanaedu.dao.impl;

import com.pahanaedu.dao.ItemDAO;
import com.pahanaedu.model.Item;
import com.pahanaedu.util.ConnectionFactory;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.math.BigDecimal;

public class ItemDAOImpl implements ItemDAO {
    private final ConnectionFactory cf = ConnectionFactory.getInstance();

    @Override
    public Item save(Item i) {
        String sql = "INSERT INTO items(name,price,quantity,category,description,image) VALUES (?,?,?,?,?,?)";
        try (Connection con = cf.getConnection();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, i.getName());
            ps.setBigDecimal(2, i.getPrice());
            ps.setInt(3, i.getQuantity());
            ps.setString(4, i.getCategory());
            ps.setString(5, i.getDescription());
            ps.setString(6, i.getImage());
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) i.setId(rs.getLong(1));
            }
            return i;
        } catch (SQLException e) {
            throw new RuntimeException("Item save failed", e);
        }
    }

    @Override
    public boolean update(Item i) {
        String sql = "UPDATE items SET name=?, price=?, quantity=?, category=?, description=?, image=? WHERE id=?";
        try (Connection con = cf.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, i.getName());
            ps.setBigDecimal(2, i.getPrice());
            ps.setInt(3, i.getQuantity());
            ps.setString(4, i.getCategory());
            ps.setString(5, i.getDescription());
            ps.setString(6, i.getImage());
            ps.setLong(7, i.getId());
            return ps.executeUpdate() == 1;
        } catch (SQLException e) {
            throw new RuntimeException("Item update failed", e);
        }
    }

    @Override
    public boolean deleteById(Long id) {
        String delChildren = "DELETE FROM bill_items WHERE item_id=?";
        String delItem     = "DELETE FROM items WHERE id=?";
        try (Connection con = cf.getConnection()) {
            con.setAutoCommit(false);
            try (PreparedStatement ps1 = con.prepareStatement(delChildren);
                 PreparedStatement ps2 = con.prepareStatement(delItem)) {

                ps1.setLong(1, id);
                ps1.executeUpdate();

                ps2.setLong(1, id);
                int rows = ps2.executeUpdate();

                con.commit();
                return rows == 1;
            } catch (SQLException ex) {
                con.rollback();
                throw ex;
            }
        } catch (SQLException e) {
            throw new RuntimeException("Item delete failed", e);
        }
    }
    

    @Override
    public Optional<Item> findById(Long id) {
        String sql = "SELECT * FROM items WHERE id=?";
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
    public List<Item> findAll() {
        List<Item> list = new ArrayList<>();
        String sql = "SELECT * FROM items ORDER BY id DESC";
        try (Connection con = cf.getConnection();
             Statement st = con.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) list.add(map(rs));
            return list;
        } catch (SQLException e) {
            throw new RuntimeException("findAll failed", e);
        }
    }

    private Item map(ResultSet rs) throws SQLException {
        Item i = new Item();
        i.setId(rs.getLong("id"));
        i.setName(rs.getString("name"));
        i.setPrice(rs.getBigDecimal("price"));
        i.setQuantity(rs.getInt("quantity"));
        i.setCategory(rs.getString("category"));
        i.setDescription(rs.getString("description"));
        i.setImage(rs.getString("image"));
        return i;
    }
    
    
    

    @Override
    public List<Item> search(String nameLike, Long id, String category) {
        StringBuilder sql = new StringBuilder("SELECT * FROM items WHERE 1=1");
        List<Object> params = new ArrayList<>();

        if (id != null) { sql.append(" AND id=?"); params.add(id); }
        if (nameLike != null && !nameLike.isBlank()) {
            sql.append(" AND LOWER(name) LIKE ?");
            params.add("%" + nameLike.toLowerCase() + "%");
        }
        if (category != null && !category.isBlank()) {
            sql.append(" AND category = ?");
            params.add(category);
        }
        sql.append(" ORDER BY id DESC");

        try (Connection con = cf.getConnection();
             PreparedStatement ps = con.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            List<Item> list = new ArrayList<>();
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(map(rs));
            }
            return list;
        } catch (SQLException e) {
            throw new RuntimeException("search failed", e);
        }
    }
    
    
    //for count

    @Override
    public int countAll() {
        String sql = "SELECT COUNT(*) FROM items";
        try (Connection con = cf.getConnection();
             Statement st = con.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            rs.next();
            return rs.getInt(1);
        } catch (SQLException e) {
            throw new RuntimeException("Item countAll failed", e);
        }
    }


}
