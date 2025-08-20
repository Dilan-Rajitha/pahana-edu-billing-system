package com.pahanaedu.service.impl;

import com.pahanaedu.dao.CustomerDAO;
import com.pahanaedu.dao.impl.CustomerDAOImpl;
import com.pahanaedu.model.Customer;
import com.pahanaedu.service.CustomerService;

import java.util.List;
import java.util.Optional;

public class CustomerServiceImpl implements CustomerService {
    private final CustomerDAO dao = new CustomerDAOImpl();

    @Override
    public String nextAccountNumber() {
        Integer max = dao.findMaxAccountSuffix();   
        int next = (max == null) ? 10001 : (max + 1);
        return String.format("PE-ACC-%05d", next);  // PE-ACC
    }

    @Override
    public Customer register(Customer c) {
        if (c.getAccountNumber() == null || c.getAccountNumber().isBlank()) {
            c.setAccountNumber(nextAccountNumber());
        }
        if (c.getName() == null || c.getName().isBlank()) {
            throw new IllegalArgumentException("Name is required");
        }
        dao.findByAccount(c.getAccountNumber()).ifPresent(x -> {
            throw new IllegalArgumentException("Account number already exists");
        });
        return dao.save(c);
    }

    @Override public boolean update(Customer c) { return dao.update(c); }
    @Override public boolean delete(Long id) { return dao.deleteById(id); }
    @Override public Optional<Customer> byId(Long id) { return dao.findById(id); }
    @Override public Optional<Customer> searchByAccount(String acc) { return dao.findByAccount(acc); }
    @Override public List<Customer> all() { return dao.findAll(); }
    
    
    
    //for search
    @Override
    public List<Customer> search(String keyword) {
        return dao.search(keyword);
    }

}
