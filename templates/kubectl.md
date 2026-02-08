---
name: kubectl
description: kubectlを使用してKubernetesクラスタを管理します。Pod、Deployment、Service等のリソース操作が可能です。
allowed-tools:
  - Bash(kubectl:*)
---

# kubectl スキル

kubectlはKubernetesクラスタを管理するためのコマンドラインツールです。

## 主な機能

- Pod、Deployment、Service等のリソース管理
- リソースの作成・更新・削除
- ログ表示・実行中のコンテナへのアクセス
- クラスタ情報の表示
- 設定の管理（context、namespace）

## 使用例

```bash
# 現在のcontextを確認
kubectl config current-context

# Podを一覧表示
kubectl get pods

# すべてのnamespaceのPodを表示
kubectl get pods --all-namespaces

# リソースの詳細を表示
kubectl describe pod <pod-name>

# リソースをマニフェストから作成
kubectl apply -f deployment.yaml

# リソースを削除
kubectl delete -f deployment.yaml

# Podのログを表示
kubectl logs <pod-name>

# Pod内でコマンドを実行
kubectl exec -it <pod-name> -- /bin/bash

# Podをポートフォワード
kubectl port-forward <pod-name> 8080:80

# デプロイメントをスケール
kubectl scale deployment <name> --replicas=3
```

Bashツールを使用してkubectlコマンドを実行してください。

## 注意事項

以下の操作は変更・削除を伴うため、実行前にユーザーへ確認してください：

- `kubectl delete` - リソースの削除
- `kubectl apply` - リソースの作成・更新
- `kubectl edit` - リソースのインプレース編集
- `kubectl patch` - リソースの部分的更新
- `kubectl scale` - レプリカ数の変更
- `kubectl cordon` / `kubectl drain` - ノードの操作

### 実行環境の確認

**重要**: 実行前に必ず以下を確認してください：

1. 現在のcontext: `kubectl config current-context`
2. 現在のnamespace: `kubectl config view --minify --output 'jsonpath={..namespace}'`

本番環境への操作は特に慎重に行ってください。必要に応じて、実行前に対象環境の確認をユーザーに求めてください。

### 安全な操作

- `--dry-run=client` オプションで変更内容の事前確認を推奨
- `--namespace` を明示的に指定して誤操作を防止
- 重要リソースの削除前はバックアップを推奨
