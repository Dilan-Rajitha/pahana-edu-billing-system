package com.pahanaedu.dao.impl;

import com.pahanaedu.dao.LogDAO;
import com.pahanaedu.model.LogEntry;
import com.pahanaedu.util.ConnectionFactory;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class LogDAOImpl implements LogDAO {
  private final ConnectionFactory cf = ConnectionFactory.getInstance();

  @Override
  public void add(LogEntry e) {
    String sql = "INSERT INTO logs(username,role,action,reference_type,reference_id,ip_address) VALUES(?,?,?,?,?,?)";
    try (Connection con = cf.getConnection();
         PreparedStatement ps = con.prepareStatement(sql)) {
      ps.setString(1, e.getUsername());
      ps.setString(2, e.getRole());
      ps.setString(3, e.getAction());
      if (e.getReferenceType()==null) ps.setNull(4, Types.VARCHAR); else ps.setString(4, e.getReferenceType());
      if (e.getReferenceId()==null) ps.setNull(5, Types.BIGINT); else ps.setLong(5, e.getReferenceId());
      ps.setString(6, e.getIpAddress());
      ps.executeUpdate();
    } catch (SQLException ex) {
      throw new RuntimeException("Log insert failed", ex);
    }
  }

  @Override
  public List<LogEntry> find(String username, String action, String period, int limit) {
    StringBuilder sb = new StringBuilder("SELECT * FROM logs WHERE 1=1 ");
    List<Object> params = new ArrayList<>();

    if (username != null && !username.isBlank()) {
      sb.append("AND username = ? ");
      params.add(username);
    }
    if (action != null && !action.isBlank()) {
      sb.append("AND action = ? ");
      params.add(action);
    }
    if (period != null) {
      switch (period) {
        case "today"  -> sb.append("AND DATE(created_at) = CURDATE() ");
        case "last7"  -> sb.append("AND created_at >= NOW() - INTERVAL 7 DAY ");
        case "last30" -> sb.append("AND created_at >= NOW() - INTERVAL 30 DAY ");
        case "all"    -> { /* no filter */ }
        default       -> { /* no filter */ }
      }
    }
    sb.append("ORDER BY created_at DESC ");
    sb.append("LIMIT ").append(limit <= 0 ? 200 : limit);

    List<LogEntry> list = new ArrayList<>();
    try (Connection con = cf.getConnection();
         PreparedStatement ps = con.prepareStatement(sb.toString())) {
      for (int i=0; i<params.size(); i++) {
        ps.setObject(i+1, params.get(i));
      }
      try (ResultSet rs = ps.executeQuery()) {
        while (rs.next()) {
          LogEntry e = new LogEntry();
          e.setId(rs.getLong("id"));
          e.setUsername(rs.getString("username"));
          e.setRole(rs.getString("role"));
          e.setAction(rs.getString("action"));
          e.setReferenceType(rs.getString("reference_type"));
          long rid = rs.getLong("reference_id");
          e.setReferenceId(rs.wasNull()? null : rid);
          e.setIpAddress(rs.getString("ip_address"));
          e.setCreatedAt(rs.getTimestamp("created_at"));
          list.add(e);
        }
      }
    } catch (SQLException ex) { throw new RuntimeException("Log search failed", ex); }
    return list;
  }
}
