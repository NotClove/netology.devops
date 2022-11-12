# Домашнее задание к занятию "6.2. SQL"

## Введение

Перед выполнением задания вы можете ознакомиться с 
[дополнительными материалами](https://github.com/netology-code/virt-homeworks/tree/master/additional/README.md).

## Задача 1

Используя docker поднимите инстанс PostgreSQL (версию 12) c 2 volume, 
в который будут складываться данные БД и бэкапы.

Приведите получившуюся команду или docker-compose манифест.

## Задача 2

В БД из задачи 1: 
- создайте пользователя test-admin-user и БД test_db

    ```sql
    postgres=# CREATE USER "test-admin-user"; CREATE DATABASE test_db;
    CREATE ROLE
    CREATE DATABASE
    ```

- в БД test_db создайте таблицу orders и clients (спeцификация таблиц ниже)

    ```sql
    postgres=# CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
    наименование VARCHAR,
    цена INTEGER
    );
    CREATE TABLE

    postgres=# CREATE TABLE clients (
    id SERIAL PRIMARY KEY,
    фамилия VARCHAR,
    "страна проживания" VARCHAR,
    заказ INT,
    FOREIGN KEY (заказ) REFERENCES orders (id)
    );
    CREATE TABLE
    ```

- предоставьте привилегии на все операции пользователю test-admin-user на таблицы БД test_db

    ```sql
    postgres=# GRANT ALL ON orders, clients TO "test-admin-user";
    GRANT
    ```

- создайте пользователя test-simple-user 

    ```sql
    postgres=# CREATE USER "test-simple-user";
    CREATE ROLE
    ```

- предоставьте пользователю test-simple-user права на SELECT/INSERT/UPDATE/DELETE данных таблиц БД test_db

    ```sql
    postgres=# GRANT SELECT, INSERT, UPDATE, DELETE ON orders, clients TO "test-simple-user";
    GRANT
    ```

Приведите:
- итоговый список БД после выполнения пунктов выше,

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
    test_db   | postgres | UTF8     | en_US.utf8 | en_US.utf8 |
    (4 rows)
    ```

- описание таблиц (describe)

    ```sql
    postgres=# \d clients
                                        Table "public.clients"
        Column       |       Type        | Collation | Nullable |               Default
    -------------------+-------------------+-----------+----------+-------------------------------------
    id                | integer           |           | not null | nextval('clients_id_seq'::regclass)
    фамилия           | character varying |           |          |
    страна проживания | character varying |           |          |
    заказ             | integer           |           |          |
    Indexes:
        "clients_pkey" PRIMARY KEY, btree (id)
    Foreign-key constraints:
        "clients_заказ_fkey" FOREIGN KEY ("заказ") REFERENCES orders(id)

    postgres=# \d orders
                                        Table "public.orders"
        Column    |       Type        | Collation | Nullable |              Default
    --------------+-------------------+-----------+----------+------------------------------------
    id           | integer           |           | not null | nextval('orders_id_seq'::regclass)
    наименование | character varying |           |          |
    цена         | integer           |           |          |
    Indexes:
        "orders_pkey" PRIMARY KEY, btree (id)
    Referenced by:
        TABLE "clients" CONSTRAINT "clients_заказ_fkey" FOREIGN KEY ("заказ") REFERENCES orders(id)
    ```

- SQL-запрос для выдачи списка пользователей с правами над таблицами test_db

    ```sql
    postgres=# SELECT * FROM information_schema.table_privileges WHERE table_name = 'clients' OR table_name = 'orders';
    ```

- список пользователей с правами над таблицами test_db

    ```sql
    grantor  |     grantee      | table_catalog | table_schema | table_name | privilege_type | is_grantable | with_hierarchy
    ----------+------------------+---------------+--------------+------------+----------------+--------------+----------------
    postgres | postgres         | postgres      | public       | orders     | INSERT         | YES          | NO
    postgres | postgres         | postgres      | public       | orders     | SELECT         | YES          | YES
    postgres | postgres         | postgres      | public       | orders     | UPDATE         | YES          | NO
    postgres | postgres         | postgres      | public       | orders     | DELETE         | YES          | NO
    postgres | postgres         | postgres      | public       | orders     | TRUNCATE       | YES          | NO
    postgres | postgres         | postgres      | public       | orders     | REFERENCES     | YES          | NO
    postgres | postgres         | postgres      | public       | orders     | TRIGGER        | YES          | NO
    postgres | test-admin-user  | postgres      | public       | orders     | INSERT         | NO           | NO
    postgres | test-admin-user  | postgres      | public       | orders     | SELECT         | NO           | YES
    postgres | test-admin-user  | postgres      | public       | orders     | UPDATE         | NO           | NO
    postgres | test-admin-user  | postgres      | public       | orders     | DELETE         | NO           | NO
    postgres | test-admin-user  | postgres      | public       | orders     | TRUNCATE       | NO           | NO
    postgres | test-admin-user  | postgres      | public       | orders     | REFERENCES     | NO           | NO
    postgres | test-admin-user  | postgres      | public       | orders     | TRIGGER        | NO           | NO
    postgres | test-simple-user | postgres      | public       | orders     | INSERT         | NO           | NO
    postgres | test-simple-user | postgres      | public       | orders     | SELECT         | NO           | YES
    postgres | test-simple-user | postgres      | public       | orders     | UPDATE         | NO           | NO
    postgres | test-simple-user | postgres      | public       | orders     | DELETE         | NO           | NO
    postgres | postgres         | postgres      | public       | clients    | INSERT         | YES          | NO
    postgres | postgres         | postgres      | public       | clients    | SELECT         | YES          | YES
    postgres | postgres         | postgres      | public       | clients    | UPDATE         | YES          | NO
    postgres | postgres         | postgres      | public       | clients    | DELETE         | YES          | NO
    postgres | postgres         | postgres      | public       | clients    | TRUNCATE       | YES          | NO
    postgres | postgres         | postgres      | public       | clients    | REFERENCES     | YES          | NO
    postgres | postgres         | postgres      | public       | clients    | TRIGGER        | YES          | NO
    postgres | test-admin-user  | postgres      | public       | clients    | INSERT         | NO           | NO
    postgres | test-admin-user  | postgres      | public       | clients    | SELECT         | NO           | YES
    postgres | test-admin-user  | postgres      | public       | clients    | UPDATE         | NO           | NO
    postgres | test-admin-user  | postgres      | public       | clients    | DELETE         | NO           | NO
    postgres | test-admin-user  | postgres      | public       | clients    | TRUNCATE       | NO           | NO
    postgres | test-admin-user  | postgres      | public       | clients    | REFERENCES     | NO           | NO
    postgres | test-admin-user  | postgres      | public       | clients    | TRIGGER        | NO           | NO
    postgres | test-simple-user | postgres      | public       | clients    | INSERT         | NO           | NO
    postgres | test-simple-user | postgres      | public       | clients    | SELECT         | NO           | YES
    postgres | test-simple-user | postgres      | public       | clients    | UPDATE         | NO           | NO
    postgres | test-simple-user | postgres      | public       | clients    | DELETE         | NO           | NO
    (36 rows)
    ```

## Задача 3

Используя SQL синтаксис - наполните таблицы следующими тестовыми данными:

Таблица orders

|Наименование|цена|
|------------|----|
|Шоколад| 10 |
|Принтер| 3000 |
|Книга| 500 |
|Монитор| 7000|
|Гитара| 4000|

Таблица clients

|ФИО|Страна проживания|
|------------|----|
|Иванов Иван Иванович| USA |
|Петров Петр Петрович| Canada |
|Иоганн Себастьян Бах| Japan |
|Ронни Джеймс Дио| Russia|
|Ritchie Blackmore| Russia|

    ```sql
    postgres=# INSERT INTO orders (наименование, цена) VALUES
    ('Шоколад', 10),
    ('Принтер', 3000),
    ('Книга', 500),
    ('Монитор', 7000),
    ('Гитара', 4000);
    INSERT 0 5
    postgres=# INSERT INTO clients (фамилия, "страна проживания") VALUES
    ('Иванов Иван Иванович', 'USA'),
    ('Петров Петр Петрович', 'Canada'),
    ('Иоганн Себастьян Бах', 'Japan'),
    ('Ронни Джеймс Дио', 'Russia'),
    ('Ritchie Blackmore', 'Russia');
    INSERT 0 5
    ```

Используя SQL синтаксис:
- вычислите количество записей для каждой таблицы 
- приведите в ответе:
    - запросы 
    - результаты их выполнения.

    ```sql
    postgres=# SELECT COUNT(*) FROM orders;
    ```

    ```sql
    count
    -------
        5
    (1 row)
    ```
    ```sql
    postgres=# SELECT COUNT(*) FROM clients;
    ```

    ```sql
    count
    -------
        5
    (1 row)
    ```


## Задача 4

Часть пользователей из таблицы clients решили оформить заказы из таблицы orders.

Используя foreign keys свяжите записи из таблиц, согласно таблице:

|ФИО|Заказ|
|------------|----|
|Иванов Иван Иванович| Книга |
|Петров Петр Петрович| Монитор |
|Иоганн Себастьян Бах| Гитара |

Приведите SQL-запросы для выполнения данных операций.

Приведите SQL-запрос для выдачи всех пользователей, которые совершили заказ, а также вывод данного запроса.
 
Подсказк - используйте директиву `UPDATE`.

    ```sql
    postgres=# UPDATE clients SET "заказ" = 3 WHERE фамилия = 'Иванов Иван Иванович';
    UPDATE 1
    postgres=# UPDATE clients SET "заказ" = 4 WHERE фамилия = 'Петров Петр Петрович';
    UPDATE 1
    postgres=# UPDATE clients SET "заказ" = 5 WHERE фамилия = 'Иоганн Себастьян Бах';
    UPDATE 1
    postgres=# SELECT * FROM clients WHERE заказ IS NOT NULL;
    id |       фамилия        | страна проживания | заказ
    ----+----------------------+-------------------+-------
    1 | Иванов Иван Иванович | USA               |     3
    2 | Петров Петр Петрович | Canada            |     4
    3 | Иоганн Себастьян Бах | Japan             |     5
    (3 rows)
    ```

## Задача 5

Получите полную информацию по выполнению запроса выдачи всех пользователей из задачи 4 
(используя директиву EXPLAIN).
Приведите получившийся результат и объясните что значат полученные значения.

    ```sql
    postgres=# EXPLAIN SELECT * FROM clients WHERE заказ IS NOT NULL;
                            QUERY PLAN
    -----------------------------------------------------------
    Seq Scan on clients  (cost=0.00..18.10 rows=806 width=72)
    Filter: ("заказ" IS NOT NULL)
    (2 rows)
    ```
    ```
    Стоимость получения первого значения 0.00.
    Стоимость получения всех строк 18.10.
    Приблизительное количество проверенных строк 806
    Средний размер каждой строки в байтах составил 72
    Используется фильтр "заказ" IS NOT NULL
    ```

## Задача 6

Создайте бэкап БД test_db и поместите его в volume, предназначенный для бэкапов (см. Задачу 1).

```bash
docker exec pg pg_basebackup -h localhost -U postgres -p 5432 -w -D /var/backups/pg_backup/datebase.backup -Ft
```

Остановите контейнер с PostgreSQL (но не удаляйте volumes).



Поднимите новый пустой контейнер с PostgreSQL.

Восстановите БД test_db в новом контейнере.

Приведите список операций, который вы применяли для бэкапа данных и восстановления. 

```sql
Делаем бекап:
docker exec f bash -c "pg_dumpall -U postgres > /var/backups/pg_backup/db_full.tar"
```

```sql
Проверяем что база пустая и восстанавливаем:
docker exec -it pg psql -U postgres
psql (12.12 (Debian 12.12-1.pgdg110+1))
Type "help" for help.

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

postgres=# \d clients
Did not find any relation named "clients".
postgres=# \d orders
Did not find any relation named "orders".
postgres=# exit

docker exec f bash -c "psql -U postgres -f /var/backups/pg_backup/db_full.tar"
SET
SET
SET
psql:/var/backups/pg_backup/db_full.tar:14: ERROR:  role "postgres" already exists
ALTER ROLE
CREATE ROLE
ALTER ROLE
CREATE ROLE
ALTER ROLE
You are now connected to database "template1" as user "postgres".
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
You are now connected to database "postgres" as user "postgres".
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
ALTER TABLE
GRANT
GRANT
GRANT
GRANT
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
CREATE DATABASE
ALTER DATABASE
You are now connected to database "test_db" as user "postgres".
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

docker exec -it pg psql -U postgres
psql (12.12 (Debian 12.12-1.pgdg110+1))
Type "help" for help.

postgres=# \l
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

postgres=# \d clients
                                       Table "public.clients"
      Column       |       Type        | Collation | Nullable |               Default
-------------------+-------------------+-----------+----------+-------------------------------------
 id                | integer           |           | not null | nextval('clients_id_seq'::regclass)
 фамилия           | character varying |           |          |
 страна проживания | character varying |           |          |
 заказ             | integer           |           |          |
Indexes:
    "clients_pkey" PRIMARY KEY, btree (id)
Foreign-key constraints:
    "clients_заказ_fkey" FOREIGN KEY ("заказ") REFERENCES orders(id)

postgres=# \d orders
                                    Table "public.orders"
    Column    |       Type        | Collation | Nullable |              Default
--------------+-------------------+-----------+----------+------------------------------------
 id           | integer           |           | not null | nextval('orders_id_seq'::regclass)
 наименование | character varying |           |          |
 цена         | integer           |           |          |
Indexes:
    "orders_pkey" PRIMARY KEY, btree (id)
Referenced by:
    TABLE "clients" CONSTRAINT "clients_заказ_fkey" FOREIGN KEY ("заказ") REFERENCES orders(id)
```