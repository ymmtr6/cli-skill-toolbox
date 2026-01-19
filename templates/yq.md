---
name: yq
description: yqを使用してYAML/JSON/XMLデータの解析・変換を行います。
allowed-tools:
  - Bash(yq:*)
---

# yq スキル

yqはYAML、JSON、XMLを処理するための軽量で柔軟なコマンドラインツールです。

## 主な機能

- YAML/JSON/XMLの読み取り・編集
- フォーマット間の変換（YAML ↔ JSON ↔ XML）
- フィールドの抽出・更新
- ファイルのマージ

## 使用例

```bash
# YAMLを読み取り
yq '.key' file.yaml

# YAMLをJSONに変換
yq -o=json '.' file.yaml

# フィールドを更新
yq '.key = "new_value"' file.yaml

# 複数ファイルをマージ
yq eval-all 'select(fileIndex == 0) * select(fileIndex == 1)' file1.yaml file2.yaml
```

Bashツールを使用してyqコマンドを実行してください。
