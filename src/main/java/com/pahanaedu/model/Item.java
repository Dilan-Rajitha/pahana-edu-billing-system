package com.pahanaedu.model;

import java.math.BigDecimal;

public class Item {
    private Long id;
    private String name;
    private BigDecimal price;
    private Integer quantity;
    private String category;
    private String description;
    private String image;

    public Item() {}

    public Item(Long id, String name, BigDecimal price, Integer quantity,
                String category, String description, String image) {
        this.id = id;
        this.name = name;
        this.price = price;
        this.quantity = quantity;
        this.category = category;
        this.description = description;
        this.image = image;
    }

    public Long getId() { return id; }
    
    public void setId(Long id) { this.id = id; }

    public String getName() { return name; }
    
    public void setName(String name) { this.name = name; }

    public BigDecimal getPrice() { return price; }
    
    public void setPrice(BigDecimal price) { this.price = price; }

    public Integer getQuantity() { return quantity; }
    
    public void setQuantity(Integer quantity) { this.quantity = quantity; }

    public String getCategory() { return category; }
    
    public void setCategory(String category) { this.category = category; }

    public String getDescription() { return description; }
    
    public void setDescription(String description) { this.description = description; }

    public String getImage() { return image; }
    
    public void setImage(String image) { this.image = image; }
}
