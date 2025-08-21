# 📚 Pahana Edu System

A comprehensive web-based billing and inventory management system designed specifically for bookshops and educational institutions. Built with modern web technologies to streamline business operations.

![Java](https://img.shields.io/badge/Java-ED8B00?style=flat&logo=java&logoColor=white)
![JSP](https://img.shields.io/badge/JSP-007396?style=flat&logo=java&logoColor=white)
![MySQL](https://img.shields.io/badge/MySQL-4479A1?style=flat&logo=mysql&logoColor=white)
![Tomcat](https://img.shields.io/badge/Tomcat-F8DC75?style=flat&logo=apache-tomcat&logoColor=black)

## 🌟 Features

### Core Functionality
- **User Authentication** - Secure login/logout system
- **Role-Based Access Control** - Admin and Staff roles with different permissions
- **Customer Management** - Complete CRUD operations for customer data
- **Inventory Management** - Add, update, delete, and track items
- **Billing System** - Calculate bills with discount support
- **Report Generation** - Sales reports, bill history, and analytics
- **Print Support** - Generate printable bills and receipts
- **Activity Logging** - Track all user actions and system events

### User Roles
- **👨‍💼 Admin**: Full system access, user management, reports, system configuration
- **👩‍💻 Staff**: Bill processing, customer management, item handling, basic reports

## 🛠️ Tech Stack

| Component | Technology |
|-----------|------------|
| **Frontend** | JSP, HTML5, CSS3, JavaScript |
| **Backend** | Java Servlets, JDBC |
| **Database** | MySQL 8.0+ |
| **Server** | Apache Tomcat 9.0.100 |
| **Build Tool** | Maven (recommended) |
| **Version Control** | Git & GitHub |

## 📋 Prerequisites

- **Java JDK 8+** installed
- **MySQL 8.0+** server running
- **Apache Tomcat 9.0+** server
- **Git** for version control
- **Web browser** (Chrome, Firefox, Safari, Edge)

## 🚀 Installation Guide

### 1. Clone the Repository
```bash
git clone https://github.com/Dilan-Rajitha/pahana-edu-billing-system.git
cd pahana-edu-billing-system
```

### 2. Database Setup

#### Create the Database
```sql
CREATE DATABASE IF NOT EXISTS pahanaedu 
DEFAULT CHARACTER SET utf8mb4 
COLLATE utf8mb4_unicode_ci;

USE pahanaedu;
```

#### Run the Complete Schema
Execute the following SQL script to set up all required tables:

```sql
-- Customers table
CREATE TABLE customers (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    account_number VARCHAR(30) NOT NULL UNIQUE,
    name VARCHAR(100) NOT NULL,
    address VARCHAR(200),
    phone VARCHAR(20),
    email VARCHAR(120),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Users table for authentication
CREATE TABLE users (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(60) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL, -- TEMP: plain text; later hash
    role ENUM('ADMIN','STAFF') NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Default admin user
INSERT INTO users(username,password_hash,role) VALUES ('admin','admin','ADMIN');

-- Items/Products table
CREATE TABLE IF NOT EXISTS items (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL,
    category VARCHAR(100),
    description TEXT,
    image VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Bills/Orders table
CREATE TABLE bills (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    customer_id BIGINT NULL,
    staff_user VARCHAR(50) NOT NULL,
    subtotal DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    discount_percent DECIMAL(5,2) NOT NULL DEFAULT 0.00,
    total DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_bills_customer FOREIGN KEY (customer_id) REFERENCES customers(id)
);

-- Bill items (line items)
CREATE TABLE bill_items (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    bill_id BIGINT NOT NULL,
    item_id BIGINT NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL,
    subtotal DECIMAL(10,2) NOT NULL,
    CONSTRAINT fk_bi_bill FOREIGN KEY (bill_id) REFERENCES bills(id) ON DELETE CASCADE,
    CONSTRAINT fk_bi_item FOREIGN KEY (item_id) REFERENCES items(id)
);

-- Activity logs table
CREATE TABLE IF NOT EXISTS logs (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(60) NOT NULL,
    role ENUM('ADMIN','STAFF') NOT NULL,
    action VARCHAR(40) NOT NULL, -- e.g. LOGIN, LOGOUT, BILL_CREATE, ITEM_CREATE, CUSTOMER_UPDATE
    reference_type VARCHAR(20) NULL, -- e.g. BILL, ITEM, CUSTOMER, USER
    reference_id BIGINT NULL,
    ip_address VARCHAR(45) NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_created_at (created_at),
    INDEX idx_user (username),
    INDEX idx_action (action)
);
```

### 3. Configuration

1. **Database Connection**: Update database connection settings in your configuration file:
   ```properties
   db.url=jdbc:mysql://localhost:3306/pahanaedu
   db.username=your_username
   db.password=your_password
   ```

2. **Tomcat Deployment**: 
   - Copy the WAR file to `tomcat/webapps/` directory
   - Or deploy the project directory to `tomcat/webapps/`

### 4. Access the Application
- **URL**: `http://localhost:8080/pahana-edu-system/`
- **Default Admin**: Username: `admin`, Password: `admin`

⚠️ **Security Note**: Change the default admin password immediately after first login!

## 📊 Database Schema Overview

### Entity Relationships
```
customers (1) ←→ (0..n) bills (n) ←→ (1) bill_items (n) ←→ (1) items
users (1) ←→ (0..n) logs
users ←→ bills (staff_user relationship)
```

### Key Tables
- **customers**: Customer information and account details
- **users**: System users with role-based permissions
- **items**: Product catalog with inventory tracking
- **bills**: Order/bill headers with totals and discounts
- **bill_items**: Individual line items for each bill
- **logs**: Comprehensive activity and audit trail

## 🎯 Usage Guide

### For Admin Users
1. **Dashboard**: Overview of sales, inventory, and system status
2. **User Management**: Create/manage staff accounts
3. **Reports**: Generate comprehensive business reports
4. **System Configuration**: Manage system settings and preferences
5. **Audit Logs**: Monitor all system activities

### For Staff Users
1. **Customer Management**: Add/edit customer information
2. **Item Management**: Update inventory and product details
3. **Billing**: Process sales and generate bills
4. **Basic Reports**: View sales summaries and customer reports

## 🔧 Development Setup

```bash
# Clone the repository
git clone https://github.com/Dilan-Rajitha/pahana-edu-billing-system.git

# Navigate to project directory
cd pahana-edu-billing-system

# Set up your IDE (Eclipse, IntelliJ, VSCode)
# Import as existing project

# Configure Tomcat server in your IDE
# Set up MySQL database connection
```




## 👥 Team

- **Developer**: [Dilan Rajitha](https://github.com/Dilan-Rajitha)
- **Project**: Open Source Educational Project

## 📞 Support

- **Issues**: [GitHub Issues](https://github.com/Dilan-Rajitha/pahana-edu-billing-system/issues)
- **Discussions**: [GitHub Discussions](https://github.com/Dilan-Rajitha/pahana-edu-billing-system/discussions)

## 🙏 Acknowledgments

- Thanks to all contributors who have helped improve this project
- Special thanks to the open-source community for inspiration and resources

---

**⭐ If you find this project useful, please give it a star on GitHub!**
