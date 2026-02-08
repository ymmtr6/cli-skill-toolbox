---
name: yarn
description: Yarnを使用してNode.jsパッケージの高速な管理を行います。
allowed-tools:
  - Bash(yarn:*)
---

# Yarn スキル

Yarnは高速で安全なNode.jsパッケージマネージャーです。

## 主な機能

- パッケージの並列インストール
- 依存関係の管理
- ワークスペースのサポート
- スクリプトの実行
- パッケージの公開・更新

## 使用例

```bash
# パッケージをインストール
yarn add express

# パッケージを開発依存としてインストール
yarn add --dev typescript

# パッケージをグローバルにインストール
yarn global add npm-check-updates

# すべての依存関係をインストール
yarn install

# パッケージを更新
yarn upgrade

# スクリプトを実行
yarn build

# パッケージを公開
yarn publish
```

Bashツールを使用してyarnコマンドを実行してください。

## 注意事項

以下の操作は公開・削除を伴うため、実行前にユーザーへ確認してください：

- `yarn publish` - パッケージをnpmレジストリに公開
- `yarn npm unpublish` - 公開済みパッケージの削除
- `yarn npm deprecate` - パッケージを非推奨としてマーク

### グローバルインストール

以下の操作はグローバル環境に変更を加えるため、確認してください：

- `yarn global add` - グローバルへのインストール
- `yarn global remove` - グローバルからのアンインストール
- `yarn global upgrade` - グローバルパッケージの更新

### その他の注意事項

- `yarn upgrade` でパッケージが更新されます
- `yarn upgrade-interactive` で対話的に更新可能です
- Yarn 2以降（Berry）ではコマンド体系が異なる場合があります
- プライベートパッケージの場合、認証情報の取り扱いに注意してください
