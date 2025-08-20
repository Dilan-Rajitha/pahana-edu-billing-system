package com.pahanaedu.dao;

import com.pahanaedu.model.Customer;
import java.util.List;
import java.util.Optional;

public interface CustomerDAO {
    Customer save(Customer c);
    boolean update(Customer c);
    boolean deleteById(Long id);
    
    //for count
    int countAll();


    Optional<Customer> findById(Long id);
    Optional<Customer> findByAccount(String acc);

    //find by phone
    Optional<Customer> findByPhone(String phone);

    List<Customer> findAll();

    //auto number gen
    Integer findMaxAccountSuffix(); 
    
    //customer search
    List<Customer> search(String keyword);

}
