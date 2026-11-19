-- Seller concentration: share of delivered GMV from the top 10 and top 100 sellers
-- Source table: fact_order_items (one row per order item)
-- Result: 2,970 sellers; top 10 = 13.3% of GMV; top 100 = 45.5% of GMV

WITH s AS (
  SELECT seller_id, SUM(price) AS gmv
  FROM fact_order_items
  WHERE order_status = 'delivered'
  GROUP BY seller_id
), r AS (
  SELECT gmv, ROW_NUMBER() OVER (ORDER BY gmv DESC) AS rk
  FROM s
)
SELECT COUNT(*) AS sellers,
       ROUND(100.0 * SUM(CASE WHEN rk <= 10  THEN gmv END) / SUM(gmv), 1) AS top10_share_pct,
       ROUND(100.0 * SUM(CASE WHEN rk <= 100 THEN gmv END) / SUM(gmv), 1) AS top100_share_pct
FROM r;
