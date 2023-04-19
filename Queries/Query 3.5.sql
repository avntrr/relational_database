WITH max_date AS (
  SELECT MAX(date_post) AS last_date_post
  FROM car_product
)
SELECT 
  brand,
  model,
  CAST(AVG(CASE WHEN DATE_TRUNC('month', date_post) = DATE_TRUNC('month', (SELECT last_date_post FROM max_date) - INTERVAL '6 months') THEN price END) AS INTEGER) AS avg_price_month6,
  CAST(AVG(CASE WHEN DATE_TRUNC('month', date_post) = DATE_TRUNC('month', (SELECT last_date_post FROM max_date) - INTERVAL '5 months') THEN price END) AS INTEGER) AS avg_price_month5,
  CAST(AVG(CASE WHEN DATE_TRUNC('month', date_post) = DATE_TRUNC('month', (SELECT last_date_post FROM max_date) - INTERVAL '4 months') THEN price END) AS INTEGER) AS avg_price_month4,
  CAST(AVG(CASE WHEN DATE_TRUNC('month', date_post) = DATE_TRUNC('month', (SELECT last_date_post FROM max_date) - INTERVAL '3 months') THEN price END) AS INTEGER) AS avg_price_month3,
  CAST(AVG(CASE WHEN DATE_TRUNC('month', date_post) = DATE_TRUNC('month', (SELECT last_date_post FROM max_date) - INTERVAL '2 months') THEN price END) AS INTEGER) AS avg_price_month2,
  CAST(AVG(CASE WHEN DATE_TRUNC('month', date_post) = DATE_TRUNC('month', (SELECT last_date_post FROM max_date) - INTERVAL '1 months') THEN price END) AS INTEGER) AS avg_price_month1
FROM 
  car_product
WHERE
  model LIKE '%Ertiga%'
GROUP BY 
  brand,
  model
ORDER BY 
  brand, 
  model
