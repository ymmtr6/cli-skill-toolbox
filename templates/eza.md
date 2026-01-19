---
name: eza
description: eza を使用してモダンなファイル一覧表示を行います（lsの代替）。
allowed-tools:
  - Bash(eza:*)
---

# eza スキル

ezaはlsコマンドのモダンな代替で、カラー出力とGit統合を提供します。

## 主な機能

- カラー出力
- Git状態表示
- ツリー表示
- アイコン表示

## 使用例

```bash
# 基本的な一覧表示
eza

# 詳細表示
eza -l

# 隠しファイルを含める
eza -a

# ツリー表示
eza --tree

# Git状態を表示
eza -l --git

# 特定深さでツリー表示
eza --tree --level=2

# ファイルサイズを人間が読める形式で
eza -lh
```

Bashツールを使用してezaコマンドを実行してください。
