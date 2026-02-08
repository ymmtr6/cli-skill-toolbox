---
name: docker
description: Dockerを使用してコンテナの作成、実行、管理を行います。
allowed-tools:
  - Bash(docker:*)
---

# Docker スキル

Dockerはコンテナ仮想化プラットフォームで、アプリケーションをコンテナとして実行・管理できます。

## 主な機能

- イメージのビルド・pull・push
- コンテナの作成・実行・停止・削除
- ボリューム管理
- ネットワーク管理
- Docker Composeによる複数コンテナのオーケストレーション

## 使用例

```bash
# イメージをプル
docker pull nginx:latest

# コンテナを実行
docker run -d -p 80:80 --name web-server nginx

# 実行中のコンテナを一覧表示
docker ps

# すべてのコンテナを一覧表示（停止中も含む）
docker ps -a

# コンテナを停止
docker stop web-server

# コンテナのログを表示
docker logs web-server

# コンテナ内でコマンドを実行
docker exec -it web-server /bin/bash

# イメージをビルド
docker build -t myapp:latest .

# ボリュームを作成
docker volume create my-volume
```

Bashツールを使用してdockerコマンドを実行してください。

## 注意事項

以下の操作は変更・削除を伴うため、実行前にユーザーへ確認してください：

- `docker rm` - コンテナの削除
- `docker rmi` - イメージの削除
- `docker volume rm` - ボリュームの削除
- `docker system prune` - 未使用リソースの一括削除
- `docker system prune -a` - 未使用イメージを含む全リソースの削除
- `docker network rm` - ネットワークの削除

### 特権オプションに関する注意

- `docker run --privileged` - 特権モードでの実行は慎重に行ってください
- `docker run --volume` / `-v` - ホストのディレクトリマウントは確認してください
- `docker run --publish` / `-p` - ポート公開の設定を確認してください

### データ保護

- ボリューム削除前にデータのバックアップを推奨します
- `docker commit` でコンテナの状態を保存可能です
