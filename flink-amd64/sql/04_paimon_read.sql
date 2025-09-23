-- 04_paimon_read.sql

SET 'execution.runtime-mode' = 'batch';
SET 'sql-client.execution.result-mode' = 'TABLEAU';
SET 'table.dml-sync' = 'true';

CREATE CATALOG paimon_catalog WITH (
  'type' = 'paimon',
  'warehouse' = 'file:///opt/flink/output/warehouse'
);

USE CATALOG paimon_catalog;
USE dwd;

SELECT COUNT(*) AS cnt FROM orders_paimon;
SELECT * FROM orders_paimon;
