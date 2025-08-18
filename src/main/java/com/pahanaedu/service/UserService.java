//public interface UserService {
//  User create(String username, String password, String role);
//  boolean delete(Long id);
//  List<User> all();
//}


package com.pahanaedu.service;

import com.pahanaedu.model.User;
import java.util.List;

public interface UserService {
    User create(String username, String password, String role);
    boolean delete(Long id);
    List<User> all();
}
