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
