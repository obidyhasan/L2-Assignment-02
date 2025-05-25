# 🐆 Wildlife Conservation Monitoring Assignment

---

## 3. Explain the Primary Key and Foreign Key concepts in PostgreSQL.

### 🔑 Primary Key

`Primary Key` হলো এক বা একাধিক কলামের Combination যা প্রতিটি রেকর্ড (row) কে unique করে তোলে। অর্থাৎ, ডাটাবেজ টেবিলে কোনো রেকর্ডের Primary Key দুইবার থাকতে পারে না এবং এটি কখনো NULL হতে পারে না।

✅ **মূল উদ্দেশ্য:**

- প্রতিটি row কে আলাদা করে চেনা।
- দ্রুত search ও indexing সুবিধা পাওয়া।

✅ **উদাহরণ:**

```sql
CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    email TEXT UNIQUE
);
```

এখানে user_id হলো `Primary Key`, যা প্রতিটি user কে unique ভাবে সনাক্ত করবে।

### 🔗 Foreign Key

`Foreign Key` হলো একটি কলাম বা কলামের সেট, যা অন্য টেবিলের Primary Key বা Unique Key এর সাথে relationship তৈরি করে। এর মাধ্যমে দুইটি টেবিলের মধ্যে referential integrity build করা হয়।

✅ **মূল উদ্দেশ্য:**

- টেবিলগুলোর মধ্যে logical সম্পর্ক তৈরি করা।
- ডাটার consistency বজায় রাখা।

✅ **উদাহরণ:**

```sql
CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INTEGER REFERENCES customers(customer_id),
    order_date DATE NOT NULL
);
```

এখানে `customer_id` হলো Foreign Key, যা `customers` টেবিলের `customer_id` এর সাথে link তৈরি করছে। এর মানে, প্রতিটি orders রেকর্ডের সাথে valid কোনো customer_id থাকতে হবে।

---

## 4. What is the difference between the VARCHAR and CHAR data types?

### CHAR

- `CHAR(n)`
- এটি fixed-length ডেটা টাইপ।
- প্রতিটি value তে fixed `n` সংখ্যক ক্যারেক্টার থাকবে।
- যদি input ছোট হয়, তাহলে automatic ভাবে ডান পাশে space দিয়ে length fulfilled করা হবে।

✅ **উদাহরণ:**

`CHAR(5)` ফিল্ডে **AB** input দিলে তা হবে AB (3টা স্পেস যোগ হবে)।

### VARCHAR

- `VARCHAR(n)`
- এটি variable-length ডেটা টাইপ।
- ইনপুটের length অনুযায়ী value store হয়, কোনো অতিরিক্ত space যোগ করা হয় না।
- Max length `n` পর্যন্ত হতে পারে, কিন্তু ছোট value হলে ঠিক যতটুকু দরকার, ততটুকুই store করে।

✅ **উদাহরণ:**

`VARCHAR(100)` ফিল্ডে **Hello** input দিলে ঠিক Hello-ই সংরক্ষিত হবে, কোনো স্পেস ছাড়া।

---

## 6. What are the LIMIT and OFFSET clauses used for?

### LIMIT

`LIMIT` ক্লজের মাধ্যমে কুয়েরির result থেকে কতটি রেকর্ড return দিতে হবে, তার সংখ্যা define করা হয়।

✅ **উদাহরণ:**

```sql
SELECT * FROM products
LIMIT 10;
```

এখানে সর্বাধিক ১০টি রেকর্ড রিটার্ন করবে।

### OFFSET

`OFFSET` ক্লজের মাধ্যমে রেজাল্ট থেকে কতটি রেকর্ড skip করতে হবে, তা define করা হয়।

✅ **উদাহরণ:**

```sql
SELECT * FROM products
LIMIT 10 OFFSET 10;
```

এখানে প্রথম ১০টি রেকর্ড বাদ দিয়ে পরের ১০টি রেকর্ড return দেওয়া হবে।

---

## 7. How can you modify data using UPDATE statements?

`UPDATE` স্টেটমেন্ট ব্যবহার করে PostgreSQL-এ টেবিলের বিদ্যমান রেকর্ডের ডেটা পরিবর্তন করা হয়। এটি নির্দিষ্ট condition দিয়ে এক বা একাধিক কলামের মান আপডেট করা হয়।

✅ **সিনট্যাক্স**

```sql
UPDATE table_name
SET column1 = value1, column2 = value2, ...
WHERE condition;
```

- `SET` - কোন কলাম কোন মানে আপডেট হবে, তা নির্ধারণ করে।
- `WHERE` - কোন রেকর্ড/রেকর্ডগুলো আপডেট হবে, তা নির্ধারণ করে। এটি না দিলে পুরো টেবিলের সব রেকর্ড আপডেট হবে!

✅ **উদাহরণ:**

```sql
UPDATE employees
SET salary = 65000, name = 'Rakib Hossain'
WHERE id = 7;
```

এখানে id ৭-এর employee name ও salary একসাথে আপডেট হবে।

---

## 10. How can you calculate aggregate functions like COUNT(), SUM(), and AVG() in PostgreSQL?

✅ **Aggregate Function কী?**

Aggregate ফাংশনগুলো হলো সেই ফাংশন, যা একাধিক রেকর্ড থেকে একটি summarized মান তৈরি করে, যেমন total count, total sum, average value ইত্যাদি। এগুলো সাধারণত GROUP BY ক্লজের সাথে বা পুরো টেবিলের উপর প্রয়োগ করা হয়।

✅ **COUNT() - রেকর্ড সংখ্যা গণনা করে**

```sql
SELECT COUNT(*) AS total_orders
FROM orders;
```

✅ **SUM() - যোগফল বের করে**

```sql
SELECT SUM(amount) AS total_amount
FROM orders;
```

✅ **AVG() → গড় মান বের করে**

```sql
SELECT AVG(amount) AS average_amount
FROM orders;
```

---
