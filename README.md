# devops-netology

# Домашнее задание к занятию "6.3. MySQL"

1) Выполнено.

Запуск контейнера.
```bash
constantine@constantine:~$ docker run --name mysql-netologhy -p 3306:3306 -it -v ~/data/mysql:/var/lib/mysql -e MYSQL_DATABASE=test_db -e MYSQL_ROOT_PASSWORD=123 mysql:8.0
constantine@constantine:~$ docker exec -i mysql-netologhy sh -c 'exec mysql -uroot -p"$MYSQL_ROOT_PASSWORD"' < ~/data/test_dump.sql
constantine@constantine:~$ docker exec -it mysql-netologhy mysql -p123
```

Статус БД и запросы

```bash
mysql> \s
--------------
mysql  Ver 8.0.28 for Linux on x86_64 (MySQL Community Server - GPL)

Connection id:		8
Current database:	test_db
Current user:		root@localhost
SSL:			Not in use
Current pager:		stdout
Using outfile:		''
Using delimiter:	;
Server version:		8.0.28 MySQL Community Server - GPL
Protocol version:	10
Connection:		Localhost via UNIX socket
Server characterset:	utf8mb4
Db     characterset:	utf8mb4
Client characterset:	latin1
Conn.  characterset:	latin1
UNIX socket:		/var/run/mysqld/mysqld.sock
Binary data as:		Hexadecimal
Uptime:			3 min 47 sec

Threads: 2  Questions: 13  Slow queries: 0  Opens: 142  Flush tables: 3  Open tables: 61  Queries per second avg: 0.057
--------------

mysql> use test_db
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Database changed

mysql> show tables;
+-------------------+
| Tables_in_test_db |
+-------------------+
| orders            |
+-------------------+
1 row in set (0.00 sec)


mysql> select count(*) from orders where price > 300;
+----------+
| count(*) |
+----------+
|        1 |
+----------+
1 row in set (0.03 sec)

```

2) Выполнено.

```bash
mysql> create user 'test'@'localhost' IDENTIFIED by 'test-pass' with
    ->     MAX_QUERIES_PER_HOUR 100
    ->     PASSWORD EXPIRE INTERVAL 180 DAY
    ->     FAILED_LOGIN_ATTEMPTS 3 PASSWORD_LOCK_TIME 2;
Query OK, 0 rows affected (0.28 sec)

mysql> ALTER USER 'test'@'localhost' ATTRIBUTE '{"fname":"James", "lname":"Pretty"}';
Query OK, 0 rows affected (0.67 sec)

mysql> grant SELECT on test_db.orders to 'test'@'localhost';
Query OK, 0 rows affected, 1 warning (0.17 sec)

mysql> select * from INFORMATION_SCHEMA.USER_ATTRIBUTES where user='test';
+------+-----------+---------------------------------------+
| USER | HOST      | ATTRIBUTE                             |
+------+-----------+---------------------------------------+
| test | localhost | {"fname": "James", "lname": "Pretty"} |
+------+-----------+---------------------------------------+
1 row in set (0.00 sec)

```

3) Выполнено.

```bash
mysql> SET profiling = 1;
Query OK, 0 rows affected, 1 warning (0.00 sec)
mysql>  SHOW PROFILES;
+----------+------------+-------------------+
| Query_ID | Duration   | Query             |
+----------+------------+-------------------+
|        1 | 0.00025300 | SET profiling = 1 |
+----------+------------+-------------------+
1 row in set, 1 warning (0.00 sec)

mysql> SELECT TABLE_NAME,ENGINE FROM information_schema.TABLES WHERE table_name = 'orders' and  TABLE_SCHEMA = 'test_db' ORDER BY ENGINE asc;
+------------+--------+
| TABLE_NAME | ENGINE |
+------------+--------+
| orders     | InnoDB |
+------------+--------+
1 row in set (0.00 sec)


mysql> alter table orders engine MyISAM;
Query OK, 5 rows affected (1.77 sec)
Records: 5  Duplicates: 0  Warnings: 0

mysql> alter table orders engine InnoDB;
Query OK, 5 rows affected (1.94 sec)
Records: 5  Duplicates: 0  Warnings: 0

mysql> show profiles;
+----------+------------+---------------------------------------------------------------------------------------------------------------------------------------+
| Query_ID | Duration   | Query                                                                                                                                 |
+----------+------------+---------------------------------------------------------------------------------------------------------------------------------------+
|        1 | 0.00025300 | SET profiling = 1                                                                                                                     |
|        2 | 0.00229300 | SELECT TABLE_NAME,ENGINE FROM information_schema.TABLES WHERE table_name = 'orders' and  TABLE_SCHEMA = 'test_db' ORDER BY ENGINE asc |
|        3 | 1.76307350 | alter table orders engine MyISAM                                                                                                      |
|        4 | 1.93796550 | alter table orders engine InnoDB                                                                                                      |
+----------+------------+---------------------------------------------------------------------------------------------------------------------------------------+
5 rows in set, 1 warning (0.00 sec)

```

Переключение на MyISAM произошло за 1.76 секунды, на InnoDB за 1.93 секунды.

4) Выполнено.

```bash
# Copyright (c) 2017, Oracle and/or its affiliates. All rights reserved.
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; version 2 of the License.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301 USA

#
# The MySQL  Server configuration file.
#
# For explanations see
# http://dev.mysql.com/doc/mysql/en/server-system-variables.html

[mysqld]
pid-file        = /var/run/mysqld/mysqld.pid
socket          = /var/run/mysqld/mysqld.sock
datadir         = /var/lib/mysql
secure-file-priv= NULL

innodb_flush_log_at_trx_commit=2
innodb_file_per_table=ON
innodb_log_buffer_size=1M
key_buffer_size=600М
max_binlog_size=100M

# Custom config should go here
!includedir /etc/mysql/conf.d/

```