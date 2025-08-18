package com.pahanaedu.service;

import com.pahanaedu.model.Customer;
import java.util.List;
import java.util.Optional;

public interface CustomerService {
    Customer register(Customer c);
    boolean update(Customer c);
    boolean delete(Long id);
    Optional<Customer> byId(Long id);
    Optional<Customer> searchByAccount(String acc);
    List<Customer> all();

    String nextAccountNumber(); // PE-ACC-10001, 10002...
    
    
    // for search 
 // In CustomerService.java
    List<Customer> search(String keyword);

}
