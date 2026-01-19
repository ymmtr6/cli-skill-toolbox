---
name: fzf
description: fzfを使用してファジー検索・インタラクティブな選択を行います。
allowed-tools:
  - Bash(fzf:*)
---

# fzf スキル

fzfは汎用のコマンドラインファジーファインダーです。

## 主な機能

- ファイル・ディレクトリのファジー検索
- コマンド履歴の検索
- プロセス選択
- パイプ入力からのインタラクティブ選択

## 使用例

```bash
# ファイルをファジー検索
find . -type f | fzf

# プレビュー付きで検索
fzf --preview 'cat {}'

# 複数選択を許可
fzf --multi

# 特定パターンでフィルタ
echo -e "apple\nbanana\ncherry" | fzf --filter "an"
```

注意: fzfはインタラクティブなツールのため、非インタラクティブモード（--filterオプション）での使用を推奨します。

Bashツールを使用してfzfコマンドを実行してください。
