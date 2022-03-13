# devops-netology

## Домашнее задание к занятию "6.4. PostgreSQL"

1) Выполнено.

```bash
constantine@constantine:~$ docker run --name netology-postgres -p 5432:5432 -e POSTGRES_USER=postgres -e POSTGRES_PASSWORD=pass -e POSTGRES_DB=db -e PGDATA=/var/lib/postgresql/data/pgdata -v ~/data/postgres:/var/lib/postgresql/data -d postgres:13.3-alpine3.14
constantine@constantine:~$ docker exec -it netology-postgres psql db -U postgres
```

Команды для вывода:

* вывода списка БД - \l
```bash
db=# \l  
                                 List of databases
   Name    |  Owner   | Encoding |  Collate   |   Ctype    |   Access privileges   
-----------+----------+----------+------------+------------+-----------------------
 db        | postgres | UTF8     | en_US.utf8 | en_US.utf8 | 
 postgres  | postgres | UTF8     | en_US.utf8 | en_US.utf8 | 
 template0 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
           |          |          |            |            | postgres=CTc/postgres
 template1 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
           |          |          |            |            | postgres=CTc/postgres
(4 rows)
```

* подключения к БД - \c
```bash
db=#   \c postgres
You are now connected to database "postgres" as user "postgres".
```

* вывода списка таблиц (заранее создал таблицу, т.к. бд изначально была пустой) - \dt

```bash
postgres=# \dt
        List of relations
 Schema | Name | Type  |  Owner   
--------+------+-------+----------
 public | test | table | postgres
(1 row)

```

* вывода описания содержимого таблиц - \d[S+] *название таблицы*

```bash
postgres=# \dS+ test      
                                                          Table "public.test"
   Column    |          Type          | Collation | Nullable |             Default              | Storage  | Stats target | Description 
-------------+------------------------+-----------+----------+----------------------------------+----------+--------------+-------------
 id          | integer                |           | not null | nextval('test_id_seq'::regclass) | plain    |              | 
 test_string | character varying(255) |           |          |                                  | extended |              | 
Indexes:
    "id_test" PRIMARY KEY, btree (id)
Access method: heap

```

* выхода из psql - \q

2) Выполнено.

Создание БД

```bash
constantine@constantine:~$ docker exec -it netology-postgres psql -U postgres
psql (13.3)
Type "help" for help.

postgres=# create database test_database;
CREATE DATABASE

```

Копируем файл бэкапа в volumes (по умолчанию ~/data/postgres), далее

```bash
constantine@constantine:~$ docker exec -it netology-postgres /bin/bash
bash-5.1# su
~ # cd /var/lib/postgresql/data
/var/lib/postgresql/data # psql -U postgres -f test_database.sql test_database
SET
SET
SET
SET
SET
 set_config 
------------
 
(1 row)

SET
SET
SET
SET
SET
SET
CREATE TABLE
ALTER TABLE
CREATE SEQUENCE
ALTER TABLE
ALTER SEQUENCE
ALTER TABLE
COPY 8
 setval 
--------
      8
(1 row)

ALTER TABLE


/var/lib/postgresql/data # psql -U postgres
psql (13.3)
Type "help" for help.

postgres=# \c test_database
You are now connected to database "test_database" as user "postgres".
test_database=# \d
              List of relations
 Schema |     Name      |   Type   |  Owner   
--------+---------------+----------+----------
 public | orders        | table    | postgres
 public | orders_id_seq | sequence | postgres
(2 rows)


```

3) Проведем партиционирование исходной таблицы

```bash
test_database=# alter table orders rename to orders_temp;
ALTER TABLE
test_database=# create table orders (id integer, title varchar(80), price integer) partition by range(price);
CREATE TABLE
test_database=# create table orders_less_499 partition of orders for values from (0) to (499);
CREATE TABLE
test_database=# create table orders_more_499 partition of orders for values from (499) to (999999999);
CREATE TABLE
test_database=# insert into orders (id, title, price) select * from orders_temp;
INSERT 0 8

```

При изначальном проектировании таблицы можно было сделать ее партицированной, тогда бы не пришлось менять название изначальной и переносить в нее данные.

4) ВЫполнено.

```bash
/var/lib/postgresql/data # pg_dump -U postgres -d test_database > test_database_dump.sql
/var/lib/postgresql/data # ls -l
total 12
drwx------   19 postgres root          4096 Mar 13 16:38 pgdata
-rw-rw-r--    1 1000     1000          2082 Mar 10 21:02 test_database.sql
-rw-r--r--    1 root     root          3509 Mar 13 16:41 test_database_dump.sql

```

Для уникальности можно создать индекс или первичный ключ

```bash
test_database=# create index on orders (title);
CREATE INDEX
```