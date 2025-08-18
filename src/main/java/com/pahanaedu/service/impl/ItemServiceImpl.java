package com.pahanaedu.service.impl;

import com.pahanaedu.dao.ItemDAO;
import com.pahanaedu.dao.impl.ItemDAOImpl;
import com.pahanaedu.model.Item;
import com.pahanaedu.service.ItemService;

import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;

public class ItemServiceImpl implements ItemService {
    private final ItemDAO dao = new ItemDAOImpl();

    @Override
    public Item create(Item i) {
        validate(i, false);
        return dao.save(i);
    }

    @Override
    public boolean update(Item i) {
        validate(i, true);
        return dao.update(i);
    }

    @Override
    public boolean delete(Long id) {
        return dao.deleteById(id);
    }

    @Override
    public Optional<Item> byId(Long id) {
        return dao.findById(id);
    }

    @Override
    public List<Item> all() {
        return dao.findAll();
    }
    
    //new
 // src/main/java/com/pahanaedu/service/impl/ItemServiceImpl.java
    @Override
    public List<Item> search(String nameLike, Long id, String category) {
        return dao.search(nameLike, id, category);
    }
//end new

    private void validate(Item i, boolean updating) {
        if (updating && (i.getId() == null)) {
            throw new IllegalArgumentException("ID required for update");
        }
        if (i.getName() == null || i.getName().isBlank()) {
            throw new IllegalArgumentException("Name is required");
        }
        if (i.getPrice() == null || i.getPrice().compareTo(BigDecimal.ZERO) < 0) {
            throw new IllegalArgumentException("Price must be zero or positive");
        }
        if (i.getQuantity() == null || i.getQuantity() < 0) {
            throw new IllegalArgumentException("Quantity must be zero or positive");
        }
    }
}
