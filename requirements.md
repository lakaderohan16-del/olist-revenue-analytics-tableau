# Requirements and KPI Definitions

## Business questions
1. How much revenue (GMV) does the marketplace generate, and where does it come from (time, state, category)?
2. How reliable is delivery, and is late delivery associated with lower customer review scores?
3. Which product categories drive revenue, and which have the weakest review scores?
4. How many customers come back to buy again?

## Scope
- Dataset: Olist Brazilian E-Commerce public dataset (9 CSV files, 2016-2018)
- Grain: `fact_orders` has one row per order (99,441 rows, one review per order); `fact_order_items` has one row per order item (112,650 rows)
- Revenue and delivery KPIs use delivered orders only unless stated

## KPI definitions
| KPI | Definition | Value |
|---|---|---|
| Total orders | Count of orders in `fact_orders` | 99,441 |
| Delivered orders | Orders with status "delivered" | 96,478 |
| GMV (BRL) | Sum of item prices for delivered orders (freight excluded) | 13,221,498 |
| Average order value (BRL) | Delivered GMV divided by delivered orders | about 137 |
| On-time delivery rate | Delivered orders received on or before the estimated delivery date, divided by delivered orders | 91.9% |
| Average delivery time (days) | Days from order purchase to delivery to the customer | 12.6 |
| Average review score | Mean review score (1-5) for delivered orders | 4.16 |
| Delay band | On time or early; 1-3 days late; 4-7 days late; 8+ days late | see below |
| Repeat customer rate | Customers with 2 or more orders divided by all customers, using `customer_unique_id` | 3.0% (2,801 of 93,358) |
| Top 10 category share | GMV of the 10 highest-GMV categories divided by total delivered GMV | about 62% |

## Delay bands and review scores
| Delay band | Orders | Average review score |
|---|---|---|
| On time or early | 88,705 | about 4.3 |
| 1-3 days late | 2,618 | see dashboard |
| 4-7 days late | 1,832 | see dashboard |
| 8+ days late | 3,315 | about 1.7 |

## Data quality rules
- 775 orders with no items are excluded from revenue KPIs (all are non-delivered)
- 547 orders with more than one review are reduced to one review per order
- 8 delivered orders with no delivery date are excluded from delivery-time and on-time KPIs

## Interpretation rule
Results are described as "associated with", not "caused by". This is an observational dataset.
