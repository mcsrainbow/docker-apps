-- 02_paimon_cdc.sql

SET 'execution.runtime-mode' = 'streaming';
SET 'execution.checkpointing.interval' = '5 s';
SET 'execution.checkpointing.mode' = 'EXACTLY_ONCE';
SET 'execution.checkpointing.min-pause' = '1 s';
SET 'execution.checkpointing.timeout' = '5 min';

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
  'server-id' = '996',
  'scan.startup.mode' = 'initial'
);

CREATE CATALOG paimon_catalog WITH (
  'type' = 'paimon',
  'warehouse' = 'file:///opt/flink/output/warehouse'
);

USE CATALOG paimon_catalog;
CREATE DATABASE IF NOT EXISTS dwd;
USE dwd;

CREATE TABLE IF NOT EXISTS orders_paimon (
  order_id INT,
  customer_id INT,
  region STRING,
  amount DOUBLE,
  status STRING,
  order_time TIMESTAMP(3),
  PRIMARY KEY (order_id) NOT ENFORCED
) WITH (
  'connector' = 'paimon',
  'changelog-producer' = 'input',
  'bucket' = '1'
);

USE CATALOG default_catalog;

INSERT INTO paimon_catalog.dwd.orders_paimon SELECT * FROM orders_cdc;
