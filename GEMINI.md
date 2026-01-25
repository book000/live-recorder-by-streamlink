# Gemini CLI Instructions

## 目的

このファイルは、Gemini CLI がこのプロジェクトで作業する際のコンテキストと作業方針を定義します。

## 出力スタイル

- **言語**: 日本語
- **トーン**: 簡潔で明確
- **形式**: 構造化された出力を心がける

## 共通ルール

- **会話言語**: 日本語
- **コミット規約**: [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/)
  - `<type>(<scope>): <description>` 形式
  - `<description>` は日本語で記載
  - 例: `feat: 録画品質オプションを追加`
- **日本語と英数字の間**: 半角スペースを挿入

## プロジェクト概要

### 目的

Streamlink を使ったライブストリームの自動録画システム

### 主な機能

- ライブストリーム URL の監視と自動録画
- 切断時の自動再接続（5秒間隔）
- Docker コンテナによる実行環境の提供
- ボリュームマウントによる録画ファイルの永続化

### 技術スタック

- **言語**: Bash (Shell scripting)
- **ランタイム**: Python 3 (slim)
- **主要な依存関係**: Streamlink v8.1.2
- **コンテナプラットフォーム**: Docker & Docker Compose
- **パッケージマネージャー**: pip (Python)

## コーディング規約

- **フォーマット**: ShellCheck に準拠
- **命名規則**: シェルスクリプトの標準的な命名規則に従う
- **コメント言語**: 日本語
- **エラーメッセージ言語**: 英語
- **日本語と英数字の間**: 半角スペースを挿入

## 開発コマンド

```bash
# Docker イメージのビルド
docker build -t live-recorder .

# Docker Compose での起動（デタッチモード）
docker-compose up -d

# Docker Compose での起動（フォアグラウンド）
docker-compose up

# ログの確認
docker-compose logs -f

# コンテナの停止
docker-compose down

# ShellCheck によるシェルスクリプトの検証
shellcheck entrypoint.sh

# Hadolint による Dockerfile の検証
hadolint Dockerfile
```

## 注意事項

### 認証情報とセキュリティ

- **API キーや認証情報を Git にコミットしない**
  - 環境変数は `recorder.env` で管理
  - `recorder.env` は `.gitignore` に含まれている
- **ログに個人情報や認証情報を出力しない**

### 既存ルールの優先

- プロジェクトの既存のコーディング規約とパターンに従う
- ShellCheck の警告を無視しない
- Hadolint のベストプラクティスに従う

### 既知の制約

- **Docker 専用**: このプロジェクトは Docker での実行を前提としている
- **環境変数必須**: `TARGET` と `URL` は必須の環境変数
- **再接続間隔**: 録画の再試行間隔は 5秒で固定
- **Streamlink バージョン**: `requirements.txt` でバージョンを固定（現在: v8.1.2）

## リポジトリ固有

### プロジェクト構造

- `entrypoint.sh`: メインの実行スクリプト（Bash）
- `Dockerfile`: コンテナイメージのビルド定義
- `docker-compose.yml`: サービスの起動設定
- `requirements.txt`: Python 依存関係
- `recorder.env`: 環境変数設定（Git 管理外）
- `.github/workflows/`: CI/CD パイプライン定義

### 環境変数

- **必須**:
  - `TARGET`: ストリームターゲット識別子
  - `URL`: ストリーミング URL
- **オプション**:
  - `STREAMLINK_ARG`: Streamlink への追加引数

### 録画ファイルの保存場所

- コンテナ内: `/data/recorded/${TARGET}`
- ホスト: `./data/recorded/${TARGET}`（Docker Compose のボリュームマウント）

### CI/CD パイプライン

- **ShellCheck CI**: `*.sh` ファイルの変更時に実行
- **Hadolint CI**: `Dockerfile` の変更時に実行
- **Docker CI**: イメージのビルドと Docker Hub へのプッシュ
- **Auto-reviewer**: PR への自動レビュアー追加

### Renovate による依存関係管理

- Streamlink のバージョンは Renovate により自動更新される
- Renovate が作成した PR に対しては、追加のコミットや変更を行わない
- 設定は `book000/templates` を継承している

### Docker Hub へのプッシュ

- 適切な認証情報（`DOCKER_USERNAME`, `DOCKER_PASSWORD`）が設定されている場合のみ実行される
- プッシュは GitHub Actions の Docker CI ワークフローで自動化されている

### Gemini CLI の役割

Gemini CLI は、以下の点で特に有用です：

- **Streamlink の最新仕様確認**: Streamlink の最新バージョンや新機能の調査
- **Docker のベストプラクティス確認**: Docker と Docker Compose の最新の推奨事項
- **Python パッケージの最新情報**: pip や Python 3 の最新動向
- **外部依存関係の制約確認**: Streamlink やその他の依存関係の互換性やバージョン制約
