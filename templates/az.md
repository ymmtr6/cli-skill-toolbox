---
name: az
description: Azure CLIを使用してMicrosoft Azureのリソースを管理します。
allowed-tools:
  - Bash(az:*)
---

# Azure CLI (az) スキル

Azure CLIはMicrosoft Azureのリソースを管理するためのコマンドラインツールです。

## 主な機能

- 仮想マシン、ストレージアカウント等のAzureリソース管理
- Azure ADとポリシーの管理
- Azure Functions、Container Instances等のサービス操作
- AKS（Azure Kubernetes Service）の管理

## 使用例

```bash
# 現在のサブスクリプションを設定
az account set --subscription "My Subscription"

# 仮想マシンを一覧表示
az vm list

# リソースグループを作成
az group create --name my-group --location eastus

# Azure Storageコンテナーを一覧表示
az storage container list --account-name myaccount

# Azure Functionをデプロイ
az functionapp create --resource-group my-group --consumption-plan-location eastus \
  --name my-function --storage-account mystorage --functions-version 4

# 現在の設定を確認
az account show
```

Bashツールを使用してazコマンドを実行してください。

## 注意事項

以下の操作は変更・削除を伴うため、実行前にユーザーへ確認してください：

- `az vm delete` - 仮想マシンの削除
- `az group delete` - リソースグループの削除
- `az storage account delete` - ストレージアカウントの削除
- `az sql server delete` - SQL Serverの削除
- `az functionapp delete` - Function Appの削除
- `az aks delete` - AKSクラスタの削除

### 課金に影響する操作

以下の操作は課金に影響する可能性があるため、確認してください：

- 仮想マシンの作成・起動
- SQL Database/SQL Serverの作成
- Storage Accountの作成
- App Service、Function Appの作成
- その他のリソース作成操作

実行前にリソースの料金体系を確認することを推奨します。

### 認証情報の取り扱い

- サービスプリンシパルの情報の取り扱いに注意してください
- 認証は`az login`で管理することを推奨
- サービスプリンシパルのシークレットは安全な場所に保管してください

### サブスクリプション確認

**重要**: 実行前に現在のサブスクリプションを確認してください：

```bash
# 現在のサブスクリプション確認
az account show --query name -o tsv

# すべてのサブスクリプションを一覧表示
az account list --output table
```

本番サブスクリプションでの操作は特に慎重に行ってください。
