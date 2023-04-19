SELECT product_id, brand, model, year, price
FROM car_product
WHERE model LIKE '%Yaris%'
ORDER BY price ASC
LIMIT 5