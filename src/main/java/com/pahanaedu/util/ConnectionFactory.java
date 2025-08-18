package com.pahanaedu.util;
import java.sql.*;

public final class ConnectionFactory {
  static {
    try {
      Class.forName("com.mysql.cj.jdbc.Driver"); // force load
    } catch (ClassNotFoundException e) {
      throw new RuntimeException("MySQL Driver not found on classpath", e);
    }
  }

  private static final String URL  = "jdbc:mysql://localhost:3306/pahanaedu?useSSL=false&serverTimezone=UTC";
  private static final String USER = "root";   // change if needed
  private static final String PASS = "2001";   // change if needed

  private static ConnectionFactory instance;
  private ConnectionFactory(){}

  public static synchronized ConnectionFactory getInstance(){
    return (instance==null) ? (instance=new ConnectionFactory()) : instance;
  }
  public Connection getConnection() throws SQLException {
    return DriverManager.getConnection(URL, USER, PASS);
  }
}
