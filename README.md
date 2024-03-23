# aws-terraform-template

Template for aws by terraform

# terraform

infra のテンプレート

## 環境

- 必要に応じてテンプレートを作成してください

| branch | 環境      |
| ------ | --------- |
| xxxx   | test 環境 |

## 構成

![aws drawio]()

## 環境

- terraform v1.4.4
- tfenv v3.0.0

## ディレクトリ構造

- .github
  - Terraform CICD フローを設定している
- backend-bucket
  - アプリケーションのリモートバックエンドを作成する Terraform コード
  - ※ 最初に実行する
- environment
  - アプリケーションの main.tf を配置
- modules
  - アプリケーションの AWS リソースを管理するモジュール一覧を配置
- .terraform-version

## セットアップ

### install terraform, tfenv

```bash
# install terraform
brew install terraform

# install tfenv
brew install tfenv

# install terraform version 1.4.4
tfenv install 1.4.4

# set terraform version to 1.4.4
tfenv use 1.4.4
```

### （必ず最初に実行） Terraform リモートバックエンドを作成

`environment/{環境}` でデプロイする前に環境ごとにリモートバックエンドを作成する

作成することでどの環境でデプロイを行っても差分は S3 に格納される

```bash
cd backend-bucket/environment/test

terraform init

terraform apply
```

### Terraform デプロイ

```bash
cd environment/stg

terraform init

terraform apply
```

### Terreform の確認

```
terraform fmt -recursive
```

サブディレクトリまでまとめてフォーマットをかける事ができる
