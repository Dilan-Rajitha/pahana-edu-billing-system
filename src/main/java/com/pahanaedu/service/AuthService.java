package com.pahanaedu.service;
public interface AuthService {
  /** returns role if ok; else null */
  String authenticate(String username, String password);
}
