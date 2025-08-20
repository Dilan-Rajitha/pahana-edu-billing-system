package com.pahanaedu.dao;
import com.pahanaedu.model.User;
import java.util.*;
public interface UserDAO {

	
	Optional<User> findById(Long id);
	
	User save(User u);
	
	boolean delete(Long id);
	
	List<User> findAll();
	
	Optional<User> findByUsername(String username);

}
