package com.pahanaedu.dao;

import com.pahanaedu.model.Item;
import java.util.List;
import java.util.Optional;

public interface ItemDAO {
    Item save(Item i);
    boolean update(Item i);
    boolean deleteById(Long id);
    Optional<Item> findById(Long id);
    List<Item> findAll();   
    //for count
    int countAll();
    // search/filter
    List<Item> search(String nameLike, Long id, String category);
}
