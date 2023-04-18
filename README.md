# CREATE A RELATIONAL DATABASE FOR A CARBEKAS.COM

This is a relational database creation project for the website 'CarBekas.com', a used car buying and selling platform in Indonesia.

**Here is the Entity Relationship Diagram (ERD) for the 'CarBekas.com' website.**

<img width="1171" alt="Screenshot 2023-04-16 at 12 46 00" src="https://user-images.githubusercontent.com/54851225/232653374-5d19a45a-25be-4735-9246-6d069e51d963.png">

Tables and dummy data are created using *python* and then inserted into *postgreSQL*. The steps performed are as follows:
### A. Import Library
```python
import pandas as pd
import numpy as np
import random
from faker import Faker
```
### B. Creating Tables
#### B.2. Table city
This table will be used as information on the city location of the car, seller, and buyer. Data is retrieved from the CSV file that already contains the city ID, city name, and coordinates.
```python
df_city = pd.read_csv('.../city - city.csv', delimiter=',')
df_city
```
#### B.3. Table car_product
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

