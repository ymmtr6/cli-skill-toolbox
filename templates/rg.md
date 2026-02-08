---
name: rg
description: ripgrep (rg) を使用して高速なテキスト検索を行います。
allowed-tools:
  - Bash(rg:*)
---

# ripgrep (rg) スキル

ripgrepは非常に高速なテキスト検索ツールです。.gitignoreを自動的に尊重します。

## 主な機能

- 高速な正規表現検索
- .gitignore対応
- ファイルタイプフィルタリング
- 置換機能

## 使用例

```bash
# 基本的な検索
rg "pattern"

# 特定ファイルタイプで検索
rg -t py "import"

# 大文字小文字を無視
rg -i "pattern"

# ファイル名のみ表示
rg -l "pattern"

# コンテキスト行を表示
rg -C 3 "pattern"

# 隠しファイルも検索
rg --hidden "pattern"
```

Bashツールを使用してrgコマンドを実行してください。

## 注意事項

以下の操作はコマンド実行を伴うため、実行前にユーザーへ確認してください：

- `rg -x` / `rg --exec` - 検索結果に対してコマンドを実行するオプション
- `rg --replace` に `-o` / `--only-matching` を組み合わせた使用は注意が必要

特に削除操作（`rm`）や変更操作を行うコマンドを実行する場合は、必ずユーザーの確認を得てください。

また、`rg --replace` を使用したファイル上書き（パイプしてリダイレクト等）は、実行前にユーザーへ確認してください。
