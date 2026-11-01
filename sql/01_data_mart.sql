-- Olist data mart: builds two clean tables from the 9 raw tables
-- fact_orders: one row per order (one review per order, items and payments totalled)
-- fact_order_items: one row per item, with category and seller details

DROP TABLE IF EXISTS fact_orders;
CREATE TABLE fact_orders AS
WITH items AS (
  SELECT order_id, COUNT(*) AS items,
         ROUND(SUM(price),2) AS gmv, ROUND(SUM(freight_value),2) AS freight
  FROM olist_order_items GROUP BY order_id
),
pay AS (
  SELECT order_id, ROUND(SUM(payment_value),2) AS payment_value
  FROM olist_order_payments GROUP BY order_id
),
rev AS (
  SELECT order_id, review_score FROM (
    SELECT order_id, review_score,
           ROW_NUMBER() OVER (PARTITION BY order_id
             ORDER BY review_creation_date DESC, review_answer_timestamp DESC) AS rn
    FROM olist_order_reviews
  ) WHERE rn = 1
)
SELECT o.order_id, c.customer_unique_id, c.customer_state, c.customer_city,
       o.order_status,
       substr(o.order_purchase_timestamp,1,7) AS purchase_month,
       o.order_purchase_timestamp, o.order_delivered_customer_date,
       o.order_estimated_delivery_date,
       CASE WHEN o.order_status='delivered' AND o.order_delivered_customer_date IS NOT NULL
            THEN ROUND(julianday(o.order_delivered_customer_date)-julianday(o.order_purchase_timestamp),1) END AS delivery_days,
       CASE WHEN o.order_status='delivered' AND o.order_delivered_customer_date IS NOT NULL
            THEN ROUND(julianday(o.order_delivered_customer_date)-julianday(o.order_estimated_delivery_date),1) END AS delay_days,
       CASE WHEN o.order_status='delivered' AND o.order_delivered_customer_date IS NOT NULL
            THEN CASE WHEN o.order_delivered_customer_date <= o.order_estimated_delivery_date THEN 1 ELSE 0 END END AS on_time_flag,
       COALESCE(i.items,0) AS items, COALESCE(i.gmv,0) AS gmv,
       COALESCE(i.freight,0) AS freight, p.payment_value, r.review_score
FROM olist_orders o
JOIN olist_customers c ON o.customer_id = c.customer_id
LEFT JOIN items i ON o.order_id = i.order_id
LEFT JOIN pay p ON o.order_id = p.order_id
LEFT JOIN rev r ON o.order_id = r.order_id;

DROP TABLE IF EXISTS fact_order_items;
CREATE TABLE fact_order_items AS
SELECT i.order_id, i.order_item_id, i.product_id, i.seller_id, i.price, i.freight_value,
       COALESCE(t.product_category_name_english, p.product_category_name, 'unknown') AS category,
       s.seller_state, s.seller_city,
       f.order_status, f.purchase_month, f.customer_state, f.review_score, f.on_time_flag
FROM olist_order_items i
JOIN fact_orders f ON i.order_id = f.order_id
LEFT JOIN olist_products p ON i.product_id = p.product_id
LEFT JOIN product_category_name_translation t ON p.product_category_name = t.product_category_name
LEFT JOIN olist_sellers s ON i.seller_id = s.seller_id;
