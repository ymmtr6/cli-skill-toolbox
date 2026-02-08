---
name: npm
description: npmを使用してNode.jsパッケージの管理を行います。インストール、更新、公開等が可能です。
allowed-tools:
  - Bash(npm:*)
---

# npm スキル

npmはNode Package Managerで、Node.jsのパッケージを管理するためのツールです。

## 主な機能

- パッケージのインストール・アンインストール
- 依存関係の管理
- スクリプトの実行
- パッケージの公開・更新

## 使用例

```bash
# パッケージをインストール
npm install express

# パッケージを開発依存としてインストール
npm install --save-dev typescript

# パッケージをグローバルにインストール
npm install -g npm-check-updates

# パッケージを更新
npm update

# 依存関係をチェック
npm audit

# スクリプトを実行
npm run build

# パッケージを公開
npm publish
```

Bashツールを使用してnpmコマンドを実行してください。

## 注意事項

以下の操作は公開・削除を伴うため、実行前にユーザーへ確認してください：

- `npm publish` - パッケージをnpmレジストリに公開
- `npm unpublish` - 公開済みパッケージの削除（72時間以内のみ可能）
- `npm deprecate` - パッケージを非推奨としてマーク
- `npm owner remove` - パッケージの所有者から削除

### グローバルインストール

以下の操作はグローバル環境に変更を加えるため、確認してください：

- `npm install -g` / `npm install --global` - グローバルへのインストール
- `npm uninstall -g` / `npm uninstall --global` - グローバルからのアンインストール
- `npm update -g` - グローバルパッケージの更新

### その他の注意事項

- `npm audit fix` でパッケージが更新される場合があります
- `npm ci` はpackage-lock.jsonに基づいてクリーンインストールを行います
- プライベートパッケージの場合、認証情報の取り扱いに注意してください
