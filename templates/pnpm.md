---
name: pnpm
description: pnpmを使用してNode.jsパッケージのディスク効率の良い管理を行います。
allowed-tools:
  - Bash(pnpm:*)
---

# pnpm スキル

pnpmは高速でディスク容量を節約するNode.jsパッケージマネージャーです。

## 主な機能

- ハードリンクによる効率的なストレージ使用
- 厳格な依存関係管理
- ワークスペースのサポート
- スクリプトの実行
- パッケージの公開・更新

## 使用例

```bash
# パッケージをインストール
pnpm add express

# パッケージを開発依存としてインストール
pnpm add -D typescript

# パッケージをグローバルにインストール
pnpm add -g npm-check-updates

# すべての依存関係をインストール
pnpm install

# パッケージを更新
pnpm update

# スクリプトを実行
pnpm build

# パッケージを公開
pnpm publish
```

Bashツールを使用してpnpmコマンドを実行してください。

## 注意事項

以下の操作は公開・削除を伴うため、実行前にユーザーへ確認してください：

- `pnpm publish` - パッケージをnpmレジストリに公開
- `pnpm unpublish` - 公開済みパッケージの削除
- `pnpm deprecate` - パッケージを非推奨としてマーク

### グローバルインストール

以下の操作はグローバル環境に変更を加えるため、確認してください：

- `pnpm add -g` / `pnpm add --global` - グローバルへのインストール
- `pnpm remove -g` / `pnpm remove --global` - グローバルからのアンインストール
- `pnpm update -g` - グローバルパッケージの更新

### その他の注意事項

- `pnpm update` でパッケージが更新されます
- `pnpm patch` でパッケージにパッチを適用可能です
- pnpmはnode_modulesの構造が他のパッケージマネージャーと異なります
- プライベートパッケージの場合、認証情報の取り扱いに注意してください
