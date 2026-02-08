---
name: aws
description: AWS CLIを使用してAmazon Web Servicesのリソースを管理します。
allowed-tools:
  - Bash(aws:*)
---

# AWS CLI (aws) スキル

AWS CLIはAmazon Web Servicesのリソースを管理するためのコマンドラインツールです。

## 主な機能

- EC2、S3、RDS等のAWSリソース管理
- IAMユーザー・ロール・ポリシーの管理
- Lambda、CloudWatch等のサーバーレスサービス操作
- CloudFormation、Terraform等のIaCツールとの連携

## 使用例

```bash
# S3バケットを一覧表示
aws s3 ls

# EC2インスタンスを一覧表示
aws ec2 describe-instances

# S3オブジェクトをコピー
aws s3 cp file.txt s3://my-bucket/file.txt

# Lambda関数を呼び出し
aws lambda invoke --function-name my-function response.json

# CloudWatchログを取得
aws logs tail /aws/lambda/my-function --follow

# 現在のユーザー情報を取得
aws sts get-caller-identity
```

Bashツールを使用してawsコマンドを実行してください。

## 注意事項

以下の操作は変更・削除を伴うため、実行前にユーザーへ確認してください：

- `aws ec2 terminate-instances` - EC2インスタンスの削除
- `aws s3 rb` - S3バケットの削除
- `aws rds delete-db-instance` - RDSインスタンスの削除
- `aws iam delete-*` - IAMリソースの削除
- `aws lambda delete-function` - Lambda関数の削除
- `aws cloudformation delete-stack` - CloudFormationスタックの削除

### 課金に影響する操作

以下の操作は課金に影響する可能性があるため、確認してください：

- EC2インスタンスの作成・起動
- RDSインスタンスの作成
- S3バケットの作成（特にバージョニング有効時）
- Lambda関数の作成
- その他のリソース作成操作

実行前にリソースの料金体系を確認することを推奨します。

### 認証情報の取り扱い

- アクセスキー、シークレットキーの取り扱いに注意してください
- 認証情報は環境変数や~/.aws/credentialsで管理することを推奨
- MFAが有効な場合は、一時的な認証情報の使用を推奨

### プロファイル確認

**重要**: 実行前に現在のプロファイルとリージョンを確認してください：

```bash
# 現在の設定確認
aws configure list

# 呼び出し元身分確認
aws sts get-caller-identity
```

本番アカウントでの操作は特に慎重に行ってください。
