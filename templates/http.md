---
name: http
description: HTTPieを使用して人間に優しいHTTPリクエストを行います。
allowed-tools:
  - Bash(http:*)
---

# HTTPie (http) スキル

HTTPieは人間に優しいHTTPクライアントです。直感的な構文でHTTPリクエストを行えます。

## 主な機能

- 直感的な構文（`http METHOD URL [ITEM [ITEM]]`）
- デフォルトで色付き・整形された出力
- JSONサポート（自動シリアライズ・デシリアライズ）
- 認証（Basic, Digest, Bearer等）
- ファイルのアップロード・ダウンロード
- セッションの保存と再利用

## 使用例

```bash
# GETリクエスト
http GET https://api.example.com/data

# POSTリクエスト（JSON）
http POST https://api.example.com/create name=value description=text

# ヘッダーを指定
http GET https://api.example.com Authorization:"Bearer TOKEN"

# ファイルをアップロード
http POST https://api.example.com/upload @file.txt

# 認証付きリクエスト
http -a username:password GET https://api.example.com

# レスポンスのみ表示
http GET https://api.example.com -h  # ヘッダーのみ
http GET https://api.example.com -b  # ボディのみ
```

Bashツールを使用してhttpコマンドを実行してください。

## 注意事項

以下の操作は変更・削除を伴うため、実行前にユーザーへ確認してください：

- `http POST` / `http PUT` / `http PATCH` - データの作成・更新操作
- `http DELETE` - データの削除操作
- `http --download` / `http -d` で既存ファイルに上書きする場合

### 認証情報の取り扱い

- トークン、パスワード等の認証情報を取り扱う場合は、特に注意してください
- `.httpie` セッションファイルに認証情報が含まれる可能性があるため、共有する際は注意してください
- 可能であれば環境変数や設定ファイルを使用することを推奨します
