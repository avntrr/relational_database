# A SIMPLE ERD FOR USED CAR WEBSITE

This is a relational database creation project for the website 'CarBekas.com', a used car buying and selling platform in Indonesia.

**Here is the Entity Relationship Diagram (ERD) for the 'CarBekas.com' website.**

<img width="1171" alt="Screenshot 2023-04-16 at 12 46 00" src="https://user-images.githubusercontent.com/54851225/232653374-5d19a45a-25be-4735-9246-6d069e51d963.png">

Tables and dummy data are created using *python* and then inserted into *postgreSQL*. The steps performed are as follows:
You can easily download full script in [database folder](https://github.com/avntrr/relational_database_ilham-x8rh/blob/main/Database/sql_project.ipynb)
## 1. CREATE DATABASE
### A. IMPORT LIBRARY
```python
import pandas as pd
import numpy as np
import random
from faker import Faker
```
### B. CREATE TABLES
#### B.1. CITY TABLE
This table will be used as information on the city location of the car, seller, and buyer. Data is retrieved from the CSV file that already contains the city ID, city name, and coordinates.
```python
df_city = pd.read_csv('.../city - city.csv', delimiter=',')
df_city
```
#### B.2. CAR_PRODUCT TABLE
Data is retrieved from the CSV file.
```python
df_car_product = pd.read_csv('.../car_product - car_product.csv', delimiter=',')
```
Add dummy data:
```python
# list of cars
brands = df_car_product['brand'].unique().tolist()

# random 200 data
rows = []
for i in range(450):
    # select random brand
    random_brand = random.choice(brands)
    
    # select random model
    random_model = df_car_product[df_car_product['brand']==random_brand]['model'].sample(n=1).iloc[0]
    
    # random year 2021-2022
    random_year = random.randint(2010, 2022)
    
    # random price between 80juta dan 450juta
    random_price = random.randint(80000000, 450000000)
    
    # select body type
    random_body_type = df_car_product[df_car_product['model']==random_model]['body_type'].sample(n=1).iloc[0]

    new_data = {'product_id':max(df_car_product['product_id'])+1, 'brand':random_brand, 'model':random_model, 'body_type':random_body_type, 'year':random_year, 'price':random_price}

    df_car_product = df_car_product.append(new_data, ignore_index=True)
```
Adding other dummy data:
1. Transmission type (Manual, Automatic)
2. Car color (Red, Yellow, Blue, Black, White)
3. Posting date
4. Mileage
5. Bid option (Available, Not Available)
6. city id

```python
kota_id = df_city['kota_id'].unique().tolist()

date_post = pd.date_range(start='2022-01-02', end='2022-12-1', periods=len(df_car_product)).to_list()
random.shuffle(date_post)

transmisi = ['manual', 'matic']
warna = ['merah', 'kuning', 'biru', 'hitam', 'putih']
opsi_bid = ['tersedia', 'tidak_tersedia']


df_car_product['transmisi'] = [random.choice(transmisi) for i in range(len(df_car_product))]
df_car_product['warna'] = [random.choice(warna) for i in range(len(df_car_product))]
df_car_product['opsi_bid'] = [random.choice(opsi_bid) for i in range(len(df_car_product))]
df_car_product['date_post'] = [d.date() for d in date_post]
df_car_product['total_km'] = [random.randint(40000, 100000)for i in range(len(df_car_product))]
df_car_product['kota_id'] = [random.choice(kota_id) for i in range(len(df_car_product))]
```
#### B.3. SELLER TABLE
```python
df_seller = pd.DataFrame()

fake = Faker('id_ID')
# Membuat data frame buyer dengan kolom-kolom buyer_id, first_name, last_name, email, phone, dan alamat
id_list = range(1, 101)
df_seller = pd.DataFrame({'seller_id': id_list})
df_seller['firstname'] = [fake.first_name() for i in id_list]
df_seller['lastname'] = [fake.last_name() for i in id_list]
df_seller['fullname'] = [f"{df_seller['firstname'][i]} {df_seller['lastname'][i]}" for i in range(len(df_seller))]
df_seller['email'] = [f"{name.lower().replace(' ', '')}@{fake.free_email_domain()}" \
                        for name in df_seller['fullname']]
df_seller['phone'] = [fake.phone_number() for i in range(len(df_seller))]
df_seller['alamat'] = [random.choice(df_city['nama_kota']) for i in range(len(df_seller))]


date_post = pd.date_range(start='2022-01-02', end='2022-12-1', periods=len(df_seller))

df_seller['date_created'] = [d.date() for d in date_post]

# Menampilkan data frame buyer
df_seller.head(10)
```
add *'seller_id'* to *df_car_product*
```python
# add 'seller_id' to df_car_product randomly
df_car_product['seller_id'] = [random.choice(df_seller['seller_id']) for i in range(len(df_car_product))]

# change "date_created" value in df_car_product if bigger than "date_post"
for index, row in df_car_product.iterrows():
    seller_id = row['seller_id']
    date_created = df_seller.loc[df_seller['seller_id'] == seller_id, 'date_created'].values[0]
    if date_created > row['date_post']:
        df_car_product.at[index, 'date_post'] = date_created

df_car_product.head(10)
```

#### B.4. BUYER TABLE
```python
df_buyer = pd.DataFrame()

# Membuat data frame buyer dengan kolom-kolom buyer_id, first_name, last_name, email, phone, dan alamat
id_list = range(1, 61)
df_buyer = pd.DataFrame({'buyer_id': id_list})
df_buyer['firstname'] = [fake.first_name() for i in id_list]
df_buyer['lastname'] = [fake.last_name() for i in id_list]
df_buyer['fullname'] = [f"{df_buyer['firstname'][i]} {df_buyer['lastname'][i]}" for i in range(len(df_buyer))]
df_buyer['email'] = [f"{name.lower().replace(' ', '')}@{fake.free_email_domain()}" \
                        for name in df_buyer['fullname']]
df_buyer['phone'] = [fake.phone_number() for i in range(len(df_buyer))]
df_buyer['alamat'] = [random.choice(df_city['nama_kota']) for i in range(len(df_buyer))]

# Menampilkan data frame buyer
df_buyer.head(10)
```
#### B.5. BID TABLE
```python
from datetime import date, timedelta

df_bid = pd.DataFrame(columns=['bid_id', 'buyer_id', 'product_id', 'bid_date', 'bid_price', 'bid_status'])

random_buyer_id = df_buyer['buyer_id'].unique().tolist()

n_bid = 1000
for i in range(n_bid):
    bid_id = i + 1
    buyer_id = random.choice(random_buyer_id)
    product_id = df_car_product['product_id'].sample(n=1).iloc[0] #add data dummy (product_id & date_post) from car_product table
    price = df_car_product[df_car_product['product_id'] == product_id]['price'].iloc[0]
    bid_price = random.uniform(price*0.5, price*0.9)
    bid_status = random.choice(['sent', 'accepted'])
    
    # create condition to stae the bid_date
    # If the product has been bid on previously, the bid_date must be greater than the previous bid_date.
    if (df_bid[(df_bid['buyer_id'] == buyer_id) & (df_bid['product_id'] == product_id)].empty):
        bid_date = date_post + timedelta(days=random.randint(1, 30))
    else:
        max_date = df_bid[(df_bid['buyer_id'] == buyer_id) & (df_bid['product_id'] == product_id)]['bid_date'].max()
        bid_date = max_date + timedelta(days=random.randint(1, 30))

    
    # Tambahkan data bid ke dalam dataframe
    df_bid.loc[i] = [bid_id, buyer_id, product_id, bid_date, bid_price, bid_status]
```
`Reindex the table`:
```python
df_bid = df_bid.reindex(columns=['bid_id', 'buyer_id', 'product_id', 'bid_date', 'bid_price', 'bid_status'])

df_bid.head(10)
```
### C. INSERT TO POSTGRESQL
```python
from sqlalchemy import create_engine

engine = create_engine('postgresql://postgres:12310101@localhost:5432/avntrr')

df_car_product.to_sql('car_product', engine, if_exists='replace', index=False)
df_city.to_sql('city', engine, if_exists='replace', index=False)
df_buyer.to_sql('buyer', engine, if_exists='replace', index=False)
df_seller.to_sql('seller', engine, if_exists='replace', index=False)
df_bid.to_sql('bid', engine, if_exists='replace', index=False)
```
We can do some query to tha database:

## 2. TRANSACTIONAL QUERY
__2.1. Searching for cars released >= 2015..__
```sql
SELECT product_id, brand, model, year, price FROM car_product
WHERE year >= 2015
```
`Output`:
![image](https://user-images.githubusercontent.com/54851225/232662442-48acbe9f-b65a-45d3-b247-0b1a1d55d717.png)

__2.2. To find cars manufactured in 2015 and later.__
```sql
SELECT product_id, buyer_id, bid_date, bid_price, bid_status
FROM bid
WHERE product_id = 78
```
`output`:
![image](https://user-images.githubusercontent.com/54851225/232662713-2a6802d6-5fa2-440b-b478-32c2fd1fa718.png)

__2.3. Show all cars being sold by one account from newest to oldest__
```sql
SELECT product_id, brand, model, year, price, date_post
FROM car_product
WHERE seller_id = 100
ORDER BY date_post DESC
```
`output`:
![image](https://user-images.githubusercontent.com/54851225/232662905-0cd23be4-3af9-4f72-84e9-42c3db6b4f34.png)

__2.4. Show the cheapest used car based on a keyword.__
```sql
SELECT product_id, brand, model, year, price
FROM car_product
WHERE model LIKE '%Yaris%'
ORDER BY price ASC
LIMIT 5
```
`output`:
![image](https://user-images.githubusercontent.com/54851225/232663034-12d73885-d4ac-4ac0-9f18-05f43bd582f5.png)

__2.5. Show the closest used car based on a city ID, the closest distance is calculated based on latitude and longitude.__<br>
To find the closest car with city ID 3173:

```sql
SELECT product_id, brand, model, year, price, nama_kota, 
       (SQRT(POWER(latitude - latitude_a, 2) + POWER(longitude - longitude_a, 2))) AS jarak 
FROM car_product 
INNER JOIN city ON car_product.kota_id = city.kota_id 
CROSS JOIN (SELECT latitude AS latitude_a, longitude AS longitude_a FROM city WHERE kota_id = 3173) AS a 
ORDER BY jarak
 ```
 `output`:
 ![image](https://user-images.githubusercontent.com/54851225/232663379-722fd9f5-47c0-4033-ba12-57e1e674e99c.png)
 
 ## 3. ANALYTICAL QUERY
 __3.1. Popularity of car models based on the number of bids.__
 ```sql
 SELECT a.model, count(a.model) AS count_product, COUNT(b.bid_id) AS count_bid
FROM car_product a
LEFT JOIN bid b
ON
a.product_id = b.product_id
GROUP BY a.model
ORDER BY count_bid DESC
```
`output`:
![image](https://user-images.githubusercontent.com/54851225/232664260-3d248016-cc4d-4e9d-b8d4-1f1706dab5ea.png)

__3.2. Compared car prices based on the average price per city.__
```sql
SELECT a.nama_kota, b.brand, b.model, b.year, CAST(AVG(b.price) AS INTEGER) AS avg_car_city
FROM city a
JOIN car_product b
ON a.kota_id = b.kota_id
GROUP  BY a.nama_kota, b.brand, b.model, b.year
LIMIT 5
```
`output`:
![image](https://user-images.githubusercontent.com/54851225/232664426-2f455a5e-7b38-4462-ba95-c7792dd9781e.png)

__3.3. From the bids on a particular car model, find the comparison between the date the user placed a bid and the next bid along with the offered price.__
```sql
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
 ```
 
`output`:
![image](https://user-images.githubusercontent.com/54851225/232664639-3bb0500b-f316-4b62-8594-bc1dced714fe.png)

__3.4. Compared the percentage difference between the average price of cars based on their model and the average bid price offered by customers in the last 6 months__
```sql
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

 ```
 `output`:
 ![image](https://user-images.githubusercontent.com/54851225/232664797-4f0fb578-9960-40f6-b35d-fad22cd20022.png)

__3.5. Create a window function for the average bid price of a brand and model of car for the last 6 months.__
```sql
WITH max_date AS (
 SELECT MAX(date_post) AS last_date_post
 FROM car_product
)
SELECT 
 brand,
 model,
 CAST(AVG(CASE WHEN DATE_TRUNC('month', date_post) = DATE_TRUNC('month', (SELECT last_date_post FROM max_date) - INTERVAL '6 months') THEN price END) AS INTEGER) AS avg_price_month6,
 CAST(AVG(CASE WHEN DATE_TRUNC('month', date_post) = DATE_TRUNC('month', (SELECT last_date_post FROM max_date) - INTERVAL '5 months') THEN price END) AS INTEGER) AS avg_price_month5,
 CAST(AVG(CASE WHEN DATE_TRUNC('month', date_post) = DATE_TRUNC('month', (SELECT last_date_post FROM max_date) - INTERVAL '4 months') THEN price END) AS INTEGER) AS avg_price_month4,
 CAST(AVG(CASE WHEN DATE_TRUNC('month', date_post) = DATE_TRUNC('month', (SELECT last_date_post FROM max_date) - INTERVAL '3 months') THEN price END) AS INTEGER) AS avg_price_month3,
 CAST(AVG(CASE WHEN DATE_TRUNC('month', date_post) = DATE_TRUNC('month', (SELECT last_date_post FROM max_date) - INTERVAL '2 months') THEN price END) AS INTEGER) AS avg_price_month2,
 CAST(AVG(CASE WHEN DATE_TRUNC('month', date_post) = DATE_TRUNC('month', (SELECT last_date_post FROM max_date) - INTERVAL '1 months') THEN price END) AS INTEGER) AS avg_price_month1
FROM 
 car_product
WHERE
 model LIKE '%Yaris%'
GROUP BY 
 brand,
 model
ORDER BY 
 brand, 
 model
 ```
 `output`:
 ![image](https://user-images.githubusercontent.com/54851225/232664993-7c294363-b743-40f4-86f2-0d0279e23a0b.png)
 
 ## DBMS USED
 PostgreSQL 14
 ## USAGE
 1. Download this repository.
 2. Install PostgreSQL 14.
 3. Create your own setting on postgreSQL 14 (root password, connection, etc.). Use this [article](https://www.postgresqltutorial.com/postgresql-getting-started/install-postgresql/) for reference.
 4. Run `backup.sql` in folder `Backup`.
 
 Now you are free to play with `SELECT` queries. 
