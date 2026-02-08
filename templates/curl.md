---
name: curl
description: curlを使用してHTTPリクエストを行います。ファイルのアップロード・ダウンロード、API操作などが可能です。
allowed-tools:
  - Bash(curl:*)
---

# curl スキル

curlはコマンドラインでHTTPリクエストを行うためのツールです。

## 主な機能

- HTTP/HTTPSリクエスト（GET, POST, PUT, DELETE等）
- ファイルのアップロード・ダウンロード
- 認証（Basic, Bearer Token, クライアント証明書等）
- ヘッダーのカスタマイズ
- クッキーの扱い
- プロキシ設定

## 使用例

```bash
# GETリクエスト
curl https://api.example.com/data

# POSTリクエスト（JSON）
curl -X POST -H "Content-Type: application/json" \
  -d '{"key":"value"}' https://api.example.com/create

# ファイルをダウンロード
curl -O https://example.com/file.zip

# 認証付きリクエスト
curl -u username:password https://api.example.com

# ヘッダーを指定
curl -H "Authorization: Bearer TOKEN" https://api.example.com
```

Bashツールを使用してcurlコマンドを実行してください。

## 注意事項

以下の操作は変更・削除を伴うため、実行前にユーザーへ確認してください：

- `curl -X POST` / `curl -X PUT` / `curl -X PATCH` - データの作成・更新操作
- `curl -X DELETE` - データの削除操作
- `curl -T` / `curl --upload-file` - ファイルのアップロード
- `curl -o` / `curl -O` で既存ファイルに上書きする場合

### 認証情報の取り扱い

- トークン、パスワード等の認証情報を取り扱う場合は、特に注意してください
- ログや履歴に認証情報が残らないよう注意してください
- 可能であれば環境変数や設定ファイルを使用することを推奨します
