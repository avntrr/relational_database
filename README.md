<h1>Create a relational database for a used car buying and selling website</h1>

Ini adalah project pembuatan relational database untuk website 'CarBekas.com', situs jual - beli mobil bekas untuk wilayah Indonesia.

**Berikut adalah ERD untuk website 'CarBekas.com'**

<img width="1171" alt="Screenshot 2023-04-16 at 12 46 00" src="https://user-images.githubusercontent.com/54851225/232653374-5d19a45a-25be-4735-9246-6d069e51d963.png">

Tabel dan data dummy dibuat menggunakan python kemudian insert ke postgreSQL. Langkah-langkah yang dilakukan adalah sebagai berikut: <br>
__1. Import Library__
```python
import pandas as pd
import numpy as np
import random
from faker import Faker
```
__2. Import file csv nama-nama kota di Indonesia dan koordinatnya__ <br>
Tabel ini akan digunakan sebagai informasi kota lokasi mobil, penjual, dan pembeli
```python
df_city = pd.read_csv('.../city - city.csv', delimiter=',')
df_city
```
