/* 1. Mencari mobil keluaran 2015 ke atas */
SELECT product_id, brand, model, year, price FROM car_product
WHERE year >= 2015


-- 2. Melihat semua mobil yg dijual 1 akun dari yg paling baru

SELECT product_id, buyer_id, bid_date, bid_price, bid_status
FROM bid
WHERE product_id = 78


-- 3. Melihat semua mobil yg dijual 1 akun dari yg paling baru

SELECT product_id, brand, model, year, price, date_post
FROM car_product
WHERE seller_id = 100
ORDER BY date_post DESC


-- 4. Mencari mobil bekas yang termurah berdasarkan keyword

SELECT product_id, brand, model, year, price
FROM car_product
WHERE model LIKE '%Yaris%'
ORDER BY price ASC
LIMIT 5


-- 5. Mencari mobil bekas yang terdekat berdasarkan sebuah id kota, jarak terdekat dihitung berdasarkan latitude longitude

SELECT product_id, brand, model, year, price, nama_kota, 
       (SQRT(POWER(latitude - latitude_a, 2) + POWER(longitude - longitude_a, 2))) AS jarak 
FROM car_product 
INNER JOIN city ON car_product.kota_id = city.kota_id 
CROSS JOIN (SELECT latitude AS latitude_a, longitude AS longitude_a FROM city WHERE kota_id = 3173) AS a 
ORDER BY jarak


-- 6. Ranking popularitas model mobil berdasarkan jumlah bid

SELECT a.model, count(a.model) AS count_product, COUNT(b.bid_id) AS count_bid
FROM car_product a
LEFT JOIN bid b
ON
a.product_id = b.product_id
GROUP BY a.model
ORDER BY count_bid DESC


-- 7. Membandingkan harga mobil berdasarkan harga rata-rata per kota

SELECT
	a.nama_kota, b.brand, b.model, b.year, CAST(AVG(b.price) AS INTEGER) AS avg_car_city
FROM
	city a
JOIN
	car_product b
ON
	a.kota_id = b.kota_id
GROUP  BY
	a.nama_kota, b.brand, b.model, b.year
LIMIT 5


/* 8. Dari penawaran suatu model mobil, cari perbandingan tanggal user melakukan bid
dengan bid selanjutnya beserta harga tawar yang diberikan */

SELECT
	p.model,
	a.buyer_id,
	MIN(a.bid_date) AS first_bid_date,
	MIN(b.bid_date) AS next_bid_date,
	a.bid_price AS first_bid_price,
	b.bid_price AS next_bid_price
FROM
	bid a
INNER JOIN
	bid b
ON
	a.buyer_id = b.buyer_id AND a.product_id = b.product_id AND a.bid_id < b.bid_id
INNER JOIN
	car_product p
ON
	a.product_id = p.product_id
WHERE
	p.model LIKE '%Ertiga%'
GROUP BY
	p.model, a.buyer_id, a.bid_price, b.bid_price
ORDER BY
	a.buyer_id
	

/* 9. Membandingkan persentase perbedaan rata-rata harga mobil
berdasarkan modelnya dan rata-rata harga bid yang ditawarkan
oleh customer pada 6 bulan terakhir */

SELECT
	model,
	CAST(AVG(price) AS INTEGER) AS avg_price,
	CAST(AVG(CASE WHEN date_post >= DATE_TRUNC('month', CURRENT_DATE - INTERVAL '6 months') THEN price END) AS INTEGER) AS avg_price_6month,
	CAST((AVG(price) - AVG(CASE WHEN date_post >= DATE_TRUNC('month', CURRENT_DATE - INTERVAL '6 months') THEN price END)) AS INTEGER) AS difference,
	CAST((AVG(price) - AVG(CASE WHEN date_post >= DATE_TRUNC('month', CURRENT_DATE - INTERVAL '6 months') THEN price END)) AS INTEGER)/AVG(price)*100 AS difference_percent
FROM
	car_product
GROUP BY
	model;
	

-- 10. Membuat window function rata-rata harga bid sebuah merk dan model mobil selama 6 bulan terakhir

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

