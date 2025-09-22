CREATE DATABASE IF NOT EXISTS sales;
USE sales;

CREATE TABLE orders (
  order_id INT PRIMARY KEY,
  customer_id INT,
  region VARCHAR(10),
  amount DOUBLE,
  status VARCHAR(10),
  order_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO orders VALUES
  (1001, 1, 'US', 20.5, 'NEW', NOW()),
  (1002, 2, 'EU', 35.2, 'NEW', NOW()),
  (1003, 3, 'CN', 66.6, 'NEW', NOW()),
  (1004, 4, 'UK', 38.9, 'NEW', NOW()),
  (1005, 5, 'AU', 25.3, 'NEW', NOW()),
  (1006, 6, 'JP', 33.8, 'NEW', NOW());

CREATE USER 'flink'@'%' IDENTIFIED BY 'flinkpw';
GRANT SELECT, RELOAD, SHOW DATABASES, REPLICATION SLAVE, REPLICATION CLIENT ON *.* TO 'flink'@'%';
FLUSH PRIVILEGES;
