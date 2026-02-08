---
name: gcloud
description: Google Cloud CLIを使用してGoogle Cloud Platformのリソースを管理します。
allowed-tools:
  - Bash(gcloud:*)
---

# Google Cloud CLI (gcloud) スキル

Google Cloud CLIはGoogle Cloud Platformのリソースを管理するためのコマンドラインツールです。

## 主な機能

- Compute Engine、Cloud Storage等のGCPリソース管理
- IAMとポリシーの管理
- Cloud Functions、Cloud Run等のサーバーレスサービス操作
- Kubernetes Engine（GKE）の管理

## 使用例

```bash
# 現在のプロジェクトを設定
gcloud config set project my-project

# Compute Engineインスタンスを一覧表示
gcloud compute instances list

# Cloud Storageバケットを一覧表示
gsutil ls

# Cloud Functionsをデプロイ
gcloud functions deploy my-function --runtime nodejs18

# Cloud Runにデプロイ
gcloud run deploy my-service --image gcr.io/my-project/my-image

# 現在の構成を確認
gcloud config list
```

Bashツールを使用してgcloudコマンドを実行してください。

## 注意事項

以下の操作は変更・削除を伴うため、実行前にユーザーへ確認してください：

- `gcloud compute instances delete` - Compute Engineインスタンスの削除
- `gcloud compute disks delete` - ディスクの削除
- `gsutil rm` - Cloud Storageオブジェクトの削除
- `gcloud sql instances delete` - Cloud SQLインスタンスの削除
- `gcloud functions delete` - Cloud Functionsの削除
- `gcloud container clusters delete` - GKEクラスタの削除

### 課金に影響する操作

以下の操作は課金に影響する可能性があるため、確認してください：

- Compute Engineインスタンスの作成・起動
- Cloud SQLインスタンスの作成
- Cloud Storageバケットの作成
- Cloud Functions、Cloud Runのデプロイ
- その他のリソース作成操作

実行前にリソースの料金体系を確認することを推奨します。

### 認証情報の取り扱い

- サービスアカウントキーの取り扱いに注意してください
- 認証情報は`gcloud auth login`やADC（Application Default Credentials）で管理することを推奨
- サービスアカウントキーファイルは安全な場所に保管してください

### プロジェクト確認

**重要**: 実行前に現在のプロジェクトを確認してください：

```bash
# 現在のプロジェクト確認
gcloud config get-value project

# 現在のアカウント確認
gcloud auth list
```

本番プロジェクトでの操作は特に慎重に行ってください。
