package com.pahanaedu.service.impl;

import com.pahanaedu.dao.UserDAO;
import com.pahanaedu.dao.impl.UserDAOImpl;
import com.pahanaedu.model.User;
import com.pahanaedu.service.UserService;

import java.util.List;

public class UserServiceImpl implements UserService {
    private final UserDAO dao = new UserDAOImpl();

    @Override
    public User create(String username, String password, String role) {
        User u = new User();
        u.setUsername(username);
        u.setPasswordHash(password); // TODO: hash later
        u.setRole(role);
        return dao.save(u);
    }

    @Override
    public boolean delete(Long id) {
        return dao.delete(id);
    }

    @Override
    public List<User> all() {
        return dao.findAll();
    }
}
