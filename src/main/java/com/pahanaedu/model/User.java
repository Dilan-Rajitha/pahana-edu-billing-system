package com.pahanaedu.model;
public class User {
  private Long id;
  private String username;
  private String passwordHash; 
  private String role;         
  public Long getId(){ return id; }
  public void setId(Long id){ this.id=id; }
  public String getUsername(){ return username; }
  public void setUsername(String v){ this.username=v; }
  public String getPasswordHash(){ return passwordHash; }
  public void setPasswordHash(String v){ this.passwordHash=v; }
  public String getRole(){ return role; }
  public void setRole(String v){ this.role=v; }
}
