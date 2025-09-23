-- 03_topn_batch.sql

SET 'execution.runtime-mode' = 'batch';
SET 'sql-client.execution.result-mode' = 'TABLEAU';
SET 'table.dml-sync' = 'true';

CREATE TABLE orders_jdbc (
  order_id INT,
  customer_id INT,
  region STRING,
  amount DOUBLE,
  status STRING,
  order_time TIMESTAMP(3),
  PRIMARY KEY (order_id) NOT ENFORCED
) WITH (
  'connector' = 'jdbc',
  'url' = 'jdbc:mysql://mysql:3306/sales',
  'table-name' = 'orders',
  'username' = 'flink',
  'password' = 'flinkpw'
);

CREATE TABLE top_customers (
  customer_id INT,
  total_amount DOUBLE
) WITH (
  'connector' = 'filesystem',
  'path' = '/opt/flink/output/top_customers',
  'format' = 'csv'
);

INSERT OVERWRITE top_customers
SELECT customer_id,
       CAST(SUM(amount) AS DOUBLE) AS total_amount
FROM orders_jdbc
GROUP BY customer_id
ORDER BY total_amount DESC
LIMIT 5;

SELECT * FROM top_customers;
