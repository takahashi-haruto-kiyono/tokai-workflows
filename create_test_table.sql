DROP TABLE IF EXISTS `dev_cdp_config.l0_D100_test`;

CREATE TABLE `dev_cdp_config.l0_D100_test` (
  user_id STRING,
  user_name STRING
)
PARTITION BY DATE(_PARTITIONTIME);


---確認用クエリ
SELECT * FROM `dev_cdp_config.l0_D100_test`;

----パーティション情報も確認:
SELECT 
  _PARTITIONTIME as partition_date,
  COUNT(*) as row_count
FROM `dev_cdp_config.l0_D100_test`
GROUP BY _PARTITIONTIME
ORDER BY _PARTITIONTIME;