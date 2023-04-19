SELECT product_id, brand, model, year, price, date_post
FROM car_product
WHERE seller_id = 100
ORDER BY date_post DESC