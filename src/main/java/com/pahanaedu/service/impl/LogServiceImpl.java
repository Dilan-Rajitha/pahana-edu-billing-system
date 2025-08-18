package com.pahanaedu.service.impl;

import com.pahanaedu.dao.LogDAO;
import com.pahanaedu.dao.impl.LogDAOImpl;
import com.pahanaedu.model.LogEntry;
import com.pahanaedu.service.LogService;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.List;

public class LogServiceImpl implements LogService {
  private final LogDAO dao = new LogDAOImpl();

  @Override
  public void log(HttpServletRequest req, String action, String refType, Long refId) {
    HttpSession s = req.getSession(false);
    String username = (s==null)? "unknown" : String.valueOf(s.getAttribute("user"));
    String role = (s==null)? "STAFF" : String.valueOf(s.getAttribute("role"));
    if (role==null || role.isBlank()) role = "STAFF";

    String ip = req.getHeader("X-Forwarded-For");
    if (ip == null || ip.isBlank()) ip = req.getRemoteAddr();

    LogEntry e = new LogEntry();
    e.setUsername(username);
    e.setRole(role);
    e.setAction(action);
    e.setReferenceType(refType);
    e.setReferenceId(refId);
    e.setIpAddress(ip);

    dao.add(e);
  }

  @Override
  public List<LogEntry> search(String username, String action, String period, int limit) {
    return new LogDAOImpl().find(username, action, period, limit);
  }
}
