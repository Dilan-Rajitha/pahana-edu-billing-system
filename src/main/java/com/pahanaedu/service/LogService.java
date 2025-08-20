package com.pahanaedu.service;

import com.pahanaedu.model.LogEntry;

import javax.servlet.http.HttpServletRequest;
import java.util.List;

public interface LogService {
	
  void log(HttpServletRequest req, String action, String refType, Long refId);
  
  List<LogEntry> search(String username, String action, String period, int limit);
  
}
