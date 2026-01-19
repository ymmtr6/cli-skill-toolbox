---
name: fd
description: fd を使用して高速なファイル・ディレクトリ検索を行います。
allowed-tools:
  - Bash(fd:*)
---

# fd スキル

fdはfindコマンドのシンプルで高速な代替ツールです。

## 主な機能

- 高速なファイル名検索
- .gitignore対応
- 正規表現サポート
- カラー出力

## 使用例

```bash
# パターンに一致するファイルを検索
fd "pattern"

# 特定の拡張子で検索
fd -e md

# ディレクトリのみ検索
fd -t d "pattern"

# ファイルのみ検索
fd -t f "pattern"

# 隠しファイルも含める
fd -H "pattern"

# 絶対パスで表示
fd -a "pattern"
```

Bashツールを使用してfdコマンドを実行してください。
