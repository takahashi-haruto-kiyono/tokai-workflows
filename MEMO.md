# CDP Data Pipeline - 重要メモ

## Dataform依存関係の問題

**問題:**
- Workflowsで `transitiveDependenciesIncluded: true` に設定すると
- 後続のDataform L1変換が **0件** になってしまう

**現在の設定（dev-tokai.yaml の380-392行目）:**
```yaml
- create_workflow_invocation:
    call: http.post
    args:
      url: '${"https://dataform.googleapis.com/v1beta1/" + dataform_repository + "/workflowInvocations"}'
      auth:
        type: OAuth2
      body:
        compilationResult: ${compilation_result.body.name}
        invocationConfig:
          includedTags:
            - '${"l1_" + table_id}'
          transitiveDependenciesIncluded: true  # ← これがtrueだと0件になる
    result: workflow_invocation
```

**対処法:**
- `transitiveDependenciesIncluded: true` のまま運用
- または `false` に変更する必要があるか要検証

**影響:**
- L0ロードは正常に動作
- L1 Dataform変換が0件処理になる可能性

---

## その他の重要情報

### Workflow名
- **実際の名前:** `cdp-data-pipeline`
- **間違えやすい名前:** `dev-tokai` ❌

### エラー通知設定
- **アラートポリシー:** CDP Data Pipeline - Error Alert
- **通知頻度:** 5分に1回
- **通知先:** Slack `#tokai-アラート`
- **監視対象エラー:**
  - TABLE_ID_MISMATCH
  - CONFIG_NOT_FOUND
  - BIGQUERY_LOAD_FAILED
  - LOAD_JOB_TIMEOUT
  - DATAFORM_EXECUTION_FAILED
  - DATAFORM_FAILED
  - FILE_COPY_FAILED

### BigQuery設定
- **max_bad_records:** CSVエラー許容数
  - 0の場合: 1つでもエラーがあると失敗
  - 推奨: 10程度に設定（D017で6件のCSVエラーが発生した実績あり）
