# cli-skill-toolbox

インストール済みの便利CLIコマンド(gh/jq/yqなど)を検出して、Claude CodeのSkillsとして自動登録するためのBashスクリプトです。

Claude Codeのスキルは `~/.claude/skills/<skill-name>/SKILL.md` に配置し、SKILL.md は YAML フロントマター (nameとdescription必須) + 指示本文 で構成します。
また、`allowed-tools` を指定すると、スキル有効時に Claude が許可なしで使えるツールを絞れます。

## インストール

```bash
git clone https://github.com/your-username/cli-skill-toolbox.git
cd cli-skill-toolbox
chmod +x register-skills.sh
```

## 使い方

### 基本的な使い方

```bash
# スキルを登録
./register-skills.sh

# ドライラン（実際にファイルを作成せずに確認）
./register-skills.sh --dry-run

# 登録可能なコマンドを一覧表示
./register-skills.sh --list

# ヘルプを表示
./register-skills.sh --help
```

### カスタム設定ファイルを使用

```bash
./register-skills.sh --config /path/to/custom-commands.conf
```

## ファイル構成

```
cli-skill-toolbox/
├── register-skills.sh    # メインスクリプト
├── commands.conf          # 対象コマンド設定ファイル
├── templates/             # コマンド別テンプレート
│   ├── gh.md
│   ├── jq.md
│   ├── yq.md
│   ├── fzf.md
│   ├── rg.md
│   ├── fd.md
│   ├── bat.md
│   └── eza.md
└── README.md
```

## 設定ファイル (commands.conf)

`commands.conf` で登録対象のコマンドを管理します。1行に1コマンドを記述し、`#`で始まる行はコメントとして扱われます。

```conf
# GitHub CLI
gh

# JSON/YAML処理
jq
yq
```

## テンプレートの追加

新しいコマンドのスキルを追加するには:

1. `commands.conf` にコマンド名を追加
2. `templates/<command>.md` にテンプレートファイルを作成

テンプレートファイルの形式:

```markdown
---
name: コマンド名
description: スキルの説明
allowed-tools:
  - Bash(コマンド名:*)
---

# スキル名

スキルの詳細な説明...
```

> **Note:** `allowed-tools` は `Bash(コマンド名:*)` の形式で、そのコマンドのみに制限することを推奨します。

## 対応コマンド

| コマンド | 説明 |
|---------|------|
| gh | GitHub CLI |
| jq | JSONプロセッサ |
| yq | YAML/JSON/XMLプロセッサ |
| fzf | ファジーファインダー |
| rg | ripgrep (高速テキスト検索) |
| fd | 高速ファイル検索 |
| bat | シンタックスハイライト付きcat |
| eza | モダンなls代替 |

## ライセンス

MIT
