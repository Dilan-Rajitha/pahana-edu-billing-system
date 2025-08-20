package com.pahanaedu.dao;

import com.pahanaedu.model.LogEntry;
import java.util.List;

public interface LogDAO {
  void add(LogEntry e);
  
  List<LogEntry> find(String username, String action, String period, int limit);
  
}
