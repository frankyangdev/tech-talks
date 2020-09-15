-- Databricks notebook source
-- MAGIC %md
-- MAGIC #1. Peek at the table

-- COMMAND ----------

Select * From ecommerce_demo.events LIMIT 10

-- COMMAND ----------

-- MAGIC %md
-- MAGIC #2. Get basic statistics
-- MAGIC - Overall numbers
-- MAGIC - Categoricals -> Number of categories
-- MAGIC - $445M sales in October/November, can you guess who is the seller?

-- COMMAND ----------

Select date(min(event_time)) as start,
       date(max(event_time)) as end,
       count(*) as numEvents,
       sum(case when event_type = 'view' then 1 else 0 end) as numViews,
       sum(case when event_type = 'cart' then 1 else 0 end) as numCart,
       sum(case when event_type = 'purchase' then 1 else 0 end) as numPurchases,
       count(distinct product_id) as numProducts,
       count(distinct category_id) as numCategoryIds,
       count(distinct category_code) as numCategories,
       count(distinct brand) as numBrands,
       count(distinct user_id) as numUsers,
       count(distinct user_session) as numSessions,
       round(avg(price)) as avgPrice,
       concat(round(sum(case when event_type = 'purchase' then price else 0 end) / 1000000), 'M') as totalSales
From ecommerce_demo.events
Where brand is not null and category_code is not null

-- COMMAND ----------

-- MAGIC %md
-- MAGIC #3. Statistics for the main category (category_code)
-- MAGIC - Smartphones are the most popular category (by far), one of the most expensive and with the highest purchase to view ratios!
-- MAGIC - We will choose the category_code as the recommender category

-- COMMAND ----------

Select category_code,
       count(*) as numEvents,
       round(avg(price)) as avgPrice,
       round(sum(if(event_type='purchase', 1, 0)) / count(*) * 100, 1) as percPurchase
From ecommerce_demo.events
Where category_code is not null
Group By category_code
Order By numEvents desc

-- COMMAND ----------

-- MAGIC %md
-- MAGIC #4. Activity over time
-- MAGIC Strange peak during November 15-17

-- COMMAND ----------

Select date_trunc('hour', event_time) as hour,
       count(*) as cnt
From ecommerce_demo.events
Where event_time >= '2019-10-10' and event_time <= '2019-11-20'
Group By hour

-- COMMAND ----------

