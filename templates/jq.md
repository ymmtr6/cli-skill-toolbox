---
name: jq
description: jqを使用してJSONデータの解析・変換・フィルタリングを行います。
allowed-tools:
  - Bash(jq:*)
---

# jq スキル

jqはJSONデータを処理するための軽量で柔軟なコマンドラインツールです。

## 主な機能

- JSONの整形（pretty print）
- フィールドの抽出・フィルタリング
- 配列操作（map、select、sort）
- JSONデータの変換・結合

## 使用例

```bash
# JSONを整形
cat data.json | jq '.'

# 特定フィールドを抽出
cat data.json | jq '.name'

# 配列をフィルタリング
cat data.json | jq '.items[] | select(.active == true)'

# 配列のマッピング
cat data.json | jq '.items | map(.name)'
```

Bashツールを使用してjqコマンドを実行してください。
