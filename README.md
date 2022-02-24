# devops-netology

## Домашнее задание к занятию "6.2. SQL"

1) Выполнено.

```bash
constantine@constantine:~/PycharmProjects/devops-netology$ docker pull postgres:12-alpine
constantine@constantine:~/PycharmProjects/devops-netology$ docker run --name postgres_netology_12 -v ~/data/postgres_netology/db_data:/data/db_data -v  ~/data/postgres_netology/backup:/data/backup -e POSTGRES_USER=postgres -e POSTGRES_PASSWORD=pass -p 5432:5432 -d postgres:12-alpine
```

2) Выполнено.

```bash
constantine@constantine:~$ docker exec -it postgres_netology_12 psql -U postgres
psql (12.10)
Type "help" for help.

postgres=# create user test_admin_user with password '123'
postgres=# create database test_db;
postgres=# \c test_db

test_db=# create table orders (
	id serial constraint orders_id primary key,
	name text,
	price integer
);

test_db=# create table clients (
	id serial constraint client_id primary key,
	surname text,
	country text,
	order_id integer,
	constraint order_id_fk foreign key (order_id) references orders (id)
);

test_db=# create index country_index on clients(country);

test_db=# grant all on all tables in schema public to test_admin_user;

test_db=# create user test_simple_user with password '123';

test_db=# grant SELECT,INSERT,UPDATE,DELETE on all tables in schema public to test_simple_user;

test_db=# \l
                                 List of databases
   Name    |  Owner   | Encoding |  Collate   |   Ctype    |   Access privileges   
-----------+----------+----------+------------+------------+-----------------------
 postgres  | postgres | UTF8     | en_US.utf8 | en_US.utf8 | 
 template0 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
           |          |          |            |            | postgres=CTc/postgres
 template1 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
           |          |          |            |            | postgres=CTc/postgres
 test_db   | postgres | UTF8     | en_US.utf8 | en_US.utf8 | 
(4 rows)

test_db=# select * from information_schema.role_table_grants where grantee in ('test_admin_user', 'test_simple_user');
 grantor  |     grantee      | table_catalog | table_schema | table_name | privilege_type | is_grantable | with_hierarchy 
----------+------------------+---------------+--------------+------------+----------------+--------------+----------------
 postgres | test_admin_user  | test_db       | public       | orders     | INSERT         | NO           | NO
 postgres | test_admin_user  | test_db       | public       | orders     | SELECT         | NO           | YES
 postgres | test_admin_user  | test_db       | public       | orders     | UPDATE         | NO           | NO
 postgres | test_admin_user  | test_db       | public       | orders     | DELETE         | NO           | NO
 postgres | test_admin_user  | test_db       | public       | orders     | TRUNCATE       | NO           | NO
 postgres | test_admin_user  | test_db       | public       | orders     | REFERENCES     | NO           | NO
 postgres | test_admin_user  | test_db       | public       | orders     | TRIGGER        | NO           | NO
 postgres | test_simple_user | test_db       | public       | orders     | INSERT         | NO           | NO
 postgres | test_simple_user | test_db       | public       | orders     | SELECT         | NO           | YES
 postgres | test_simple_user | test_db       | public       | orders     | UPDATE         | NO           | NO
 postgres | test_simple_user | test_db       | public       | orders     | DELETE         | NO           | NO
 postgres | test_admin_user  | test_db       | public       | clients    | INSERT         | NO           | NO
 postgres | test_admin_user  | test_db       | public       | clients    | SELECT         | NO           | YES
 postgres | test_admin_user  | test_db       | public       | clients    | UPDATE         | NO           | NO
 postgres | test_admin_user  | test_db       | public       | clients    | DELETE         | NO           | NO
 postgres | test_admin_user  | test_db       | public       | clients    | TRUNCATE       | NO           | NO
 postgres | test_admin_user  | test_db       | public       | clients    | REFERENCES     | NO           | NO
 postgres | test_admin_user  | test_db       | public       | clients    | TRIGGER        | NO           | NO
 postgres | test_simple_user | test_db       | public       | clients    | INSERT         | NO           | NO
 postgres | test_simple_user | test_db       | public       | clients    | SELECT         | NO           | YES
 postgres | test_simple_user | test_db       | public       | clients    | UPDATE         | NO           | NO
 postgres | test_simple_user | test_db       | public       | clients    | DELETE         | NO           | NO
(22 rows)

test_db=# \du+
                                              List of roles
    Role name     |                         Attributes                         | Member of | Description 
------------------+------------------------------------------------------------+-----------+-------------
 postgres         | Superuser, Create role, Create DB, Replication, Bypass RLS | {}        | 
 test_admin_user  |                                                            | {}        | 
 test_simple_user |                                                            | {}        | 
```

3) Выполнено.

```bash
test_db=# insert into orders (name, price) values ('Шоколад', 10), ('Принтер', 3000), ('Книга', 500), ('Монитор', 7000), ('Гитара', 4000);

INSERT 0 5
test_db=# select * from orders;
 id |  name   | price 
----+---------+-------
  1 | Шоколад |    10
  2 | Принтер |  3000
  3 | Книга   |   500
  4 | Монитор |  7000
  5 | Гитара  |  4000
(5 rows)

test_db=# insert into clients (surname, country) values ('Иванов Иван Иванович', 'USA'), ('Петров Петр Петрович', 'Canada'), ('Иоганн Себастьян Бах', 'Japan'), ('Ронни Джеймс Дио', 'Russia'), ('Ritchie Blackmore', 'Russia');
INSERT 0 5
test_db=# select * from clients;
 id |       surname        | country | order_id 
----+----------------------+---------+----------
  1 | Иванов Иван Иванович | USA     |         
  2 | Петров Петр Петрович | Canada  |         
  3 | Иоганн Себастьян Бах | Japan   |         
  4 | Ронни Джеймс Дио     | Russia  |         
  5 | Ritchie Blackmore    | Russia  |         
(5 rows)

test_db=# select count(*) from clients;
 count 
-------
     5
(1 row)

test_db=# select count(*) from orders;
 count 
-------
     5
(1 row)
```

4) Выполнено.

```bash
test_db=# update clients set order_id=3 where id=1;
UPDATE 1
test_db=# update clients set order_id=4 where id=2;
UPDATE 1
test_db=# update clients set order_id=5 where id=3;
UPDATE 1
test_db=# select * from clients where order_id is not null;
 id |       surname        | country | order_id 
----+----------------------+---------+----------
  1 | Иванов Иван Иванович | USA     |        3
  2 | Петров Петр Петрович | Canada  |        4
  3 | Иоганн Себастьян Бах | Japan   |        5
(3 rows)
```

5) Выполнено.

```bash
test_db=# explain select * from clients where order_id is not null;
                        QUERY PLAN                         
-----------------------------------------------------------
 Seq Scan on clients  (cost=0.00..18.10 rows=806 width=72)
   Filter: (order_id IS NOT NULL)
(2 rows)
```

6) Выполнено.

 ```bash
 constantine@constantine:~$ docker exec -t postgres_netology_12 pg_dump -U postgres test_db -f /data/backup/test_db.sql
 constantine@constantine:~$ docker run --name postgres_netology_12_2 -v ~/data/postgres_netology/db_data:/data/db_data -v  ~/data/postgres_netology/backup:/data/backup -e POSTGRES_USER=postgres -e POSTGRES_PASSWORD=pass -p 5432:5432 -d postgres:12-alpine
 
 constantine@constantine-3570R-370R-470R-450R-510R-4450RV:~$ docker exec -i postgres_netology_12_2 psql -U postgres -d test_db -f /data/backup/test_db.sql
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
CREATE TABLE
ALTER TABLE
CREATE SEQUENCE
ALTER TABLE
ALTER SEQUENCE
ALTER TABLE
ALTER TABLE
COPY 5
COPY 5
 setval 
--------
      5
(1 row)

 setval 
--------
      5
(1 row)

ALTER TABLE
ALTER TABLE
CREATE INDEX
ALTER TABLE
GRANT
GRANT
GRANT
GRANT
 
 ```