package com.pahanaedu.model;

import java.sql.Timestamp;

public class LogEntry {
  private Long id;
  private String username;
  private String role;
  private String action;
  private String referenceType;
  private Long referenceId;
  private String ipAddress;
  private Timestamp createdAt;

  public Long getId() { return id; }
  public void setId(Long id) { this.id = id; }
  public String getUsername() { return username; }
  public void setUsername(String username) { this.username = username; }
  public String getRole() { return role; }
  public void setRole(String role) { this.role = role; }
  public String getAction() { return action; }
  public void setAction(String action) { this.action = action; }
  public String getReferenceType() { return referenceType; }
  public void setReferenceType(String referenceType) { this.referenceType = referenceType; }
  public Long getReferenceId() { return referenceId; }
  public void setReferenceId(Long referenceId) { this.referenceId = referenceId; }
  public String getIpAddress() { return ipAddress; }
  public void setIpAddress(String ipAddress) { this.ipAddress = ipAddress; }
  public Timestamp getCreatedAt() { return createdAt; }
  public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
}
