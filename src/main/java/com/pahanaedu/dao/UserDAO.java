package com.pahanaedu.dao;
import com.pahanaedu.model.User;
import java.util.*;
public interface UserDAO {
//  Optional<User> findByUsername(String username);
//  User save(User u);
//  java.util.List<User> findAll();
	
	Optional<User> findById(Long id);
	User save(User u);
	boolean delete(Long id);
	List<User> findAll();
	Optional<User> findByUsername(String username);

}
