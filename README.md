<h1>CREATE A RELATIONAL DATABASE FOR A CARBEKAS.COM</h1>

This is a relational database creation project for the website 'CarBekas.com', a used car buying and selling platform in Indonesia.

**Here is the Entity Relationship Diagram (ERD) for the 'CarBekas.com' website.**

<img width="1171" alt="Screenshot 2023-04-16 at 12 46 00" src="https://user-images.githubusercontent.com/54851225/232653374-5d19a45a-25be-4735-9246-6d069e51d963.png">

Tables and dummy data are created using python and then inserted into postgreSQL. The steps performed are as follows: <br>
<h3>A. Import Library</h3><br>
```python
import pandas as pd
import numpy as np
import random
from faker import Faker
```
<h3>B. Create Tables</h3><br>
__B.2. Import the CSV file containing the names of cities in Indonesia and their coordinates__ <br>
This table will be used as information on the city location of the car, seller, and buyer.<br>
```python
df_city = pd.read_csv('.../city - city.csv', delimiter=',')
df_city
```

