package com.pahanaedu.service.impl;
import com.pahanaedu.dao.UserDAO;
import com.pahanaedu.dao.impl.UserDAOImpl;
import com.pahanaedu.model.User;
import com.pahanaedu.service.AuthService;
import java.util.Optional;

public class AuthServiceImpl implements AuthService {
  private final UserDAO dao = new UserDAOImpl();
  @Override public String authenticate(String u, String p){
    Optional<User> opt = dao.findByUsername(u);
    if(opt.isPresent()){
      User user = opt.get();
      // TODO: hash verify; TEMP: plain compare (assignment demo)
      if(p != null && p.equals(user.getPasswordHash())) return user.getRole();
    }
    return null;
  }
}
