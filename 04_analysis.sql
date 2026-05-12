select 
      c.customer_name,
      c.gender,
      c.age,
      c.city,
      c.registration_date,
      p.product_name,
      p.category ,
      p.sub_category,
      p.cost_price,
      p.list_price,
      s.order_date,
      s.quantity,
      s.unit_price,
      s.discount_percent,
      s.shipping_cost,
      s.payment_method,
      s.order_status,
      (s.quantity * s.unit_price) * (1- s.discount_percent/100)as total_sales
    from sales s
    join customers c on s.customer_id = c.customer_id
    join products p  on s.product_id = p.product_id;
    
    
-- En cox gelir getiren 5 mehsul
select * from(
     select
     p.product_name,
     sum((s.quantity * s.unit_price)*(1-s.discount_percent/100))as total_sales
     from sales s
     join products p on s.product_id = p.product_id
     group by p.product_name
     order by total_sales desc
) where rownum <= 5;

--Hansi seher ne qeder gelir getirib
select
     c.city,
     sum((s.quantity * s.unit_price)*(1-s.discount_percent/100))as total_sales
    from customers c
    join sales s on c.customer_id = s.customer_id
    group by c.city
    order by total_sales desc;
    

--En cox istifade olunan odenis metodu
select
     payment_method,
     count(order_id) as transaction_count,
     sum((quantity * unit_price)*(1-discount_percent/100))as total_sales
     from sales
     group by payment_method
     order by transaction_count;
     
--Teslim edilmis mehsullarin sayi ve deyeri
select
     order_status,
     count(order_id) as total_orders,
     sum((quantity * unit_price)*(1-discount_percent/100))as total_sales
     from sales
     where order_status = 'Delivered'
     group by order_status;
 
 

    
  
