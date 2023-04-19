SELECT product_id, brand, model, year, price, nama_kota, 
       (SQRT(POWER(latitude - latitude_a, 2) + POWER(longitude - longitude_a, 2))) AS jarak 
FROM car_product 
INNER JOIN city ON car_product.kota_id = city.kota_id 
CROSS JOIN (SELECT latitude AS latitude_a, longitude AS longitude_a FROM city WHERE kota_id = 3173) AS a 
ORDER BY jarak
