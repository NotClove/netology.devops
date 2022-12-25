# Домашнее задание к занятию "6.4. PostgreSQL"

## Задача 1

Используя docker поднимите инстанс PostgreSQL (версию 13). Данные БД сохраните в volume.

Подключитесь к БД PostgreSQL используя `psql`.

```bash
docker exec -it postgresql psql -U postgres
psql (13.9 (Debian 13.9-1.pgdg110+1))
Type "help" for help.
```

Воспользуйтесь командой `\?` для вывода подсказки по имеющимся в `psql` управляющим командам.

**Найдите и приведите** управляющие команды для:
- вывода списка БД

```sql
postgres=# \l
                                 List of databases
   Name    |  Owner   | Encoding |  Collate   |   Ctype    |   Access privileges
-----------+----------+----------+------------+------------+-----------------------
 postgres  | postgres | UTF8     | en_US.utf8 | en_US.utf8 |
 template0 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
           |          |          |            |            | postgres=CTc/postgres
 template1 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
           |          |          |            |            | postgres=CTc/postgres
(3 rows)
```

- подключения к БД

```sql
postgres=# \c postgres
You are now connected to database "postgres" as user "postgres".
```

- вывода списка таблиц


```sql
postgres=# \dt
Did not find any relations.
```

- вывода описания содержимого таблиц

```sql
postgres=# \d
Did not find any relations.
```

- выхода из psql

```sql
postgres=# \q
➜  ~ docker exec -it postgresql psql -U postgres
psql (13.9 (Debian 13.9-1.pgdg110+1))
Type "help" for help.
```

## Задача 2

Используя `psql` создайте БД `test_database`.

```sql
postgres=# CREATE DATABASE test_database;
CREATE DATABASE
```

Изучите [бэкап БД](https://github.com/netology-code/virt-homeworks/tree/master/06-db-04-postgresql/test_data).

Восстановите бэкап БД в `test_database`.

```sql
docker exec -it postgresql bash
root@882ac6eef28c:/# psql -U postgres test_database < /var/backups/pg_backup/test_dump.sql
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
```

Перейдите в управляющую консоль `psql` внутри контейнера.

Подключитесь к восстановленной БД и проведите операцию ANALYZE для сбора статистики по таблице.

```sql
postgres=# \c test_database
You are now connected to database "test_database" as user "postgres".
test_database=# ANALYZE;
ANALYZE
```

Используя таблицу [pg_stats](https://postgrespro.ru/docs/postgresql/12/view-pg-stats), найдите столбец таблицы `orders` 
с наибольшим средним значением размера элементов в байтах.

```sql
test_database=# SELECT attname, avg_width FROM pg_stats WHERE tablename = 'orders' ORDER BY attname DESC LIMIT 1;
 attname | avg_width
---------+-----------
 title   |        16
(1 row)
```

## Задача 3

Архитектор и администратор БД выяснили, что ваша таблица orders разрослась до невиданных размеров и
поиск по ней занимает долгое время. Вам, как успешному выпускнику курсов DevOps в нетологии предложили
провести разбиение таблицы на 2 (шардировать на orders_1 - price>499 и orders_2 - price<=499).

Предложите SQL-транзакцию для проведения данной операции.

```sql
test_database=# BEGIN;
BEGIN
test_database=*# ALTER TABLE orders RENAME TO orders_copy;
ALTER TABLE
test_database=*# CREATE TABLE orders AS table orders_copy WITH NO DATA;
CREATE TABLE AS
test_database=*# CREATE TABLE orders_more (
    CHECK (price > 499)
) INHERITS (orders);
CREATE TABLE
test_database=*# CREATE TABLE orders_less (
    CHECK (price <= 499)
) INHERITS (orders);
CREATE TABLE
test_database=*# CREATE RULE orders_more_insert AS
ON INSERT TO orders WHERE
    (price > 499)
DO INSTEAD
    INSERT INTO orders_more VALUES (NEW.*);
CREATE RULE
test_database=*# CREATE RULE orders_less_insert AS
ON INSERT TO orders WHERE
    (price <= 499)
DO INSTEAD
    INSERT INTO orders_less VALUES (NEW.*);
CREATE RULE
test_database=*# INSERT INTO orders
SELECT * FROM orders_copy;
INSERT 0 0
test_database=*# COMMIT;
COMMIT
test_database=# \d
              List of relations
 Schema |     Name      |   Type   |  Owner
--------+---------------+----------+----------
 public | orders        | table    | postgres
 public | orders_copy   | table    | postgres
 public | orders_id_seq | sequence | postgres
 public | orders_less   | table    | postgres
 public | orders_more   | table    | postgres
(5 rows)

test_database=# table orders_less
test_database-# ;
 id |        title         | price
----+----------------------+-------
  1 | War and peace        |   100
  3 | Adventure psql time  |   300
  4 | Server gravity falls |   300
  5 | Log gossips          |   123
  7 | Me and my bash-pet   |   499
(5 rows)

test_database=# table orders_more;
 id |       title        | price
----+--------------------+-------
  2 | My little database |   500
  6 | WAL never lies     |   900
  8 | Dbiezdmin          |   501
(3 rows)
```


Можно ли было изначально исключить "ручное" разбиение при проектировании таблицы orders?

```
Да, можно было бы создать секционирование таблицы
```

## Задача 4

Используя утилиту `pg_dump` создайте бекап БД `test_database`.

```sql
docker exec -it postgresql pg_dump -U postgres -v -f /var/backups/pg_backup/homework_backup.sql
```

Как бы вы доработали бэкап-файл, чтобы добавить уникальность значения столбца `title` для таблиц `test_database`?

```sql
CREATE TABLE public.orders (
    id integer NOT NULL,
    title character varying(80) NOT NULL UNIQUE,
    price integer DEFAULT 0
);
```