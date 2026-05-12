-- Köhn? cedveller varsa, evvelce onlarý silirik (ardýcýllýq vacibdir!)
DROP TABLE Sales CASCADE CONSTRAINTS;
DROP TABLE Customers CASCADE CONSTRAINTS;
DROP TABLE Products CASCADE CONSTRAINTS;
DROP TABLE Deleted_Products CASCADE CONSTRAINTS;

-- 1. Customers Cedveli
CREATE TABLE Customers (
    customer_id NUMBER PRIMARY KEY,
    customer_name VARCHAR2(100),
    gender VARCHAR2(10),
    age NUMBER,
    city VARCHAR2(50),
    segment VARCHAR2(20),
    registration_date DATE
);

-- 2. Products Cedveli
CREATE TABLE Products (
    product_id NUMBER PRIMARY KEY,
    product_name VARCHAR2(100),
    category VARCHAR2(50),
    sub_category VARCHAR2(50),
    cost_price NUMBER(10, 2),
    list_price NUMBER(10, 2)
);

-- 3. Sales Cedveli
CREATE TABLE Sales (
    order_id NUMBER PRIMARY KEY,
    order_date DATE,
    customer_id NUMBER REFERENCES Customers(customer_id),
    product_id NUMBER REFERENCES Products(product_id),
    quantity NUMBER,
    unit_price NUMBER(10, 2),
    discount_percent NUMBER(5, 2),
    shipping_cost NUMBER(10, 2),
    payment_method VARCHAR2(20),
    order_status VARCHAR2(20)
);

--deleted_products cedveli
CREATE TABLE Deleted_Products (
    product_id   NUMBER,
    product_name VARCHAR2(100),
    category     VARCHAR2(50),
    sub_category VARCHAR2(50),
    cost_price   NUMBER(10, 2),
    list_price   NUMBER(10, 2),
    deleted_by   VARCHAR2(50),
    deleted_at   TIMESTAMP DEFAULT CURRENT_TIMESTAMP 
);
