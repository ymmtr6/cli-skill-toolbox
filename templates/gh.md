---
name: gh
description: GitHub CLIを使用してGitHub操作を行います。リポジトリ、PR、Issue、Actions等の管理が可能です。
allowed-tools:
  - Bash(gh:*)
---

# GitHub CLI (gh) スキル

GitHub CLIを使用してGitHub関連の操作を実行します。

## 主な機能

- `gh repo` - リポジトリの作成、クローン、フォーク
- `gh pr` - プルリクエストの作成、レビュー、マージ
- `gh issue` - Issueの作成、一覧、クローズ
- `gh workflow` - GitHub Actionsワークフローの管理
- `gh release` - リリースの作成、管理
- `gh api` - GitHub APIへの直接アクセス

## 使用例

```bash
# PRの一覧表示
gh pr list

# 新しいIssueを作成
gh issue create --title "タイトル" --body "内容"

# ワークフローの実行
gh workflow run <workflow-name>
```

Bashツールを使用してghコマンドを実行してください。

## 注意事項

以下の操作は変更・削除を伴うため、実行前にユーザーへ確認してください：

- `gh pr close` / `gh pr merge` - PRのクローズ・マージ
- `gh issue close` / `gh issue delete` - Issueのクローズ・削除
- `gh repo delete` - リポジトリの削除
- `gh release delete` - リリースの削除
- `gh api -X DELETE/POST/PATCH` - 変更を伴うAPI呼び出し
