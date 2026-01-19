---
name: bat
description: bat を使用してシンタックスハイライト付きでファイル内容を表示します。
allowed-tools:
  - Bash(bat:*)
---

# bat スキル

batはcatコマンドの代替で、シンタックスハイライトとGit統合を提供します。

## 主な機能

- シンタックスハイライト
- Git差分表示
- 行番号表示
- ページング

## 使用例

```bash
# ファイルを表示
bat file.py

# 言語を指定
bat --language=json file.txt

# 行番号なしで表示
bat --style=plain file.txt

# 特定行範囲を表示
bat --line-range 10:20 file.txt

# ページャーを無効化
bat --paging=never file.txt

# 複数ファイルを連結表示
bat file1.txt file2.txt
```

Bashツールを使用してbatコマンドを実行してください。
