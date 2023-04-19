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