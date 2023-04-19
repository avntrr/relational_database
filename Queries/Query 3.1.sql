SELECT a.model, count(a.model) AS count_product, COUNT(b.bid_id) AS count_bid
FROM car_product a
LEFT JOIN bid b
ON
a.product_id = b.product_id
GROUP BY a.model
ORDER BY count_bid DESC
