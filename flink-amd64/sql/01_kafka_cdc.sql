-- 01_kafka_cdc.sql

CREATE TABLE orders_cdc (
  order_id INT,
  customer_id INT,
  region STRING,
  amount DOUBLE,
  status STRING,
  order_time TIMESTAMP(3),
  PRIMARY KEY (order_id) NOT ENFORCED
) WITH (
  'connector' = 'mysql-cdc',
  'hostname' = 'mysql',
  'port' = '3306',
  'username' = 'flink',
  'password' = 'flinkpw',
  'database-name' = 'sales',
  'table-name' = 'orders',
  'server-id' = '985',
  'scan.startup.mode' = 'initial'
);

CREATE TABLE orders_kafka (
  order_id INT,
  customer_id INT,
  region STRING,
  amount DOUBLE,
  status STRING,
  order_time TIMESTAMP(3),
  PRIMARY KEY (order_id) NOT ENFORCED
) WITH (
  'connector' = 'upsert-kafka',
  'topic' = 'orders_topic',
  'properties.bootstrap.servers' = 'kafka:9092',
  'key.format' = 'json',
  'value.format' = 'json'
);

INSERT INTO orders_kafka
SELECT * FROM orders_cdc;
