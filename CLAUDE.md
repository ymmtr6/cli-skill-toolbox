# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## プロジェクト概要

インストール済みのCLIコマンドを検出し、Claude Codeのスキルとして `~/.claude/skills/<skill-name>/SKILL.md` に自動登録するBashスクリプト。

## コマンド

```bash
# スキルを登録
./register-skills.sh

# ドライラン（確認のみ）
./register-skills.sh --dry-run

# 登録可能なコマンド一覧
./register-skills.sh --list

# カスタム設定ファイルを使用
./register-skills.sh --config /path/to/custom.conf
```

## アーキテクチャ

- `register-skills.sh` - メインスクリプト。`commands.conf`を読み取り、各コマンドがインストール済みかチェックし、対応するテンプレートを `~/.claude/skills/` にコピー
- `commands.conf` - 対象コマンドのリスト（1行1コマンド、`#`はコメント）
- `templates/<command>.md` - 各コマンドのSKILL.mdテンプレート

## テンプレート形式

```markdown
---
name: コマンド名
description: スキルの説明
allowed-tools:
  - Bash(コマンド名:*)
---

# スキル名

説明と使用例...
```

`allowed-tools` は `Bash(gh:*)` のように対象コマンドに制限する。

## 新しいコマンドの追加

1. `commands.conf` にコマンド名を追加
2. `templates/<command>.md` にテンプレートを作成（YAMLフロントマター必須: name, description）
