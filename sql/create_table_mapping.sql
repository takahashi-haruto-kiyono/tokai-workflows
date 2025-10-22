-- ============================================
-- テーブルマッピング設定テーブル作成
-- ============================================
-- 目的: Workflowsから参照するテーブル設定を管理
-- 担当: 高橋 (セットアップ)
-- 更新: 中西 (Dataform設定と連携)

CREATE TABLE IF NOT EXISTS `cdp_config.table_mapping` (
  table_id STRING NOT NULL,
  table_name STRING NOT NULL,
  load_type STRING NOT NULL,  -- full, incremental_upsert, incremental_append, initial_only
  write_disposition STRING NOT NULL,  -- WRITE_TRUNCATE, WRITE_APPEND
  skip_leading_rows INT64 DEFAULT 1,
  field_delimiter STRING DEFAULT ',',
  allow_quoted_newlines BOOL DEFAULT TRUE,
  allow_jagged_rows BOOL DEFAULT FALSE,
  max_bad_records INT64 DEFAULT 0,
  gcs_inbox_path STRING,
  primary_key ARRAY<STRING>,
  update_column STRING,
  frequency STRING,  -- daily, weekly, monthly, initial_only
  description STRING,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP(),
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP()
)
PARTITION BY DATE(created_at)
OPTIONS(
  description = "CDP data pipeline table configuration mapping"
);