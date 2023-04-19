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