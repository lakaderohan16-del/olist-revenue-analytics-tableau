# Olist Revenue and Operations Analytics

SQL + Tableau Public analysis of the Olist Brazilian e-commerce dataset (2016-2018): revenue, delivery performance, customer reviews and category performance.

**Live dashboards:** https://public.tableau.com/app/profile/rohan.lakade/viz/olist_dashboards/Executivesummary

## Dashboards
1. **Executive summary:** total GMV, delivered orders, on-time delivery, average order value, monthly GMV, top 10 states by GMV
2. **Delivery and customers:** average delivery time, review score by delivery delay, late-delivery rate by state
3. **Category performance:** top 10 categories by GMV, average review score by category

## Repository contents
- `01_load_and_validate.ipynb`: loads the 9 Olist CSVs into SQLite (Google Colab), runs data quality checks
- `sql/01_data_mart.sql`: builds the clean tables `fact_orders` (one row per order) and `fact_order_items` (one row per order item)

## Key findings (delivered orders unless stated)
- 99,441 orders in total; 96,478 delivered; delivered GMV 13,221,498 BRL; average order value about 137 BRL
- On-time delivery 91.9%; average delivery time 12.6 days; average review score 4.16
- Average review score is associated with delivery delay: about 4.3 for on-time orders, falling to about 1.7 for orders 8+ days late
- Top 10 categories account for about 62% of delivered GMV
- Highest-rated large category: luggage_accessories (4.32). Lowest-rated: office_furniture (3.49)
- Repeat customers: 2,801 of 93,358 (3.0%), identified by customer_unique_id

## Reconciliation: SQL vs Tableau
| Metric | SQL | Tableau | Match |
|---|---|---|---|
| Total orders | 99,441 | 99,441 | Yes |
| Delivered orders | 96,478 | 96,478 | Yes |
| Delivered GMV (BRL) | 13,221,498 | 13,221,498 | Yes |
| Average order value (BRL) | about 137 | 137.0 | Yes |
| On-time delivery | 91.9% | 91.9% | Yes |
| Average delivery time (days) | 12.6 | 12.6 | Yes |
| Average review score | 4.16 | 4.16 | Yes |

## Metric definitions
- **GMV** = sum of item prices in BRL (freight excluded)
- **On-time delivery** = delivered orders received on or before the estimated delivery date

## Data quality notes
- 775 orders have no items (all are non-delivered orders)
- 547 orders have more than one review; the clean table keeps one review per order
- 8 delivered orders have no delivery date

## Limitations
- The data covers 2016-2018 only and is a public dataset from one marketplace
- Findings are associations, not proof of cause: late delivery is associated with lower review scores, but other factors may also play a part
- Review scores are only available for customers who chose to leave a review
- Category-level review comparisons only include categories with 1,000+ items
- Repeat-customer rate depends on customer_unique_id being a reliable customer identifier

## Tools
SQLite, Python (Google Colab), SQL, Tableau Public
