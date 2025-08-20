package com.pahanaedu.service;

import com.pahanaedu.model.Item;
import java.util.List;
import java.util.Optional;

public interface ItemService {
    Item create(Item i);
    boolean update(Item i);
    boolean delete(Long id);
    Optional<Item> byId(Long id);
    List<Item> all();

    // NEW
    List<Item> search(String nameLike, Long id, String category);
}
