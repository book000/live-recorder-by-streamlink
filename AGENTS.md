# AI Agents Instructions

## 目的

このファイルは、一般的な AI エージェントがこのプロジェクトで作業する際の共通の作業方針を定義します。

## 基本方針

- **会話言語**: 日本語
- **コメント言語**: 日本語
- **エラーメッセージ言語**: 英語
- **コミット規約**: [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/)
  - `<type>(<scope>): <description>` 形式
  - `<description>` は日本語で記載
  - 例: `feat: 録画品質オプションを追加`
- **日本語と英数字の間**: 半角スペースを挿入

## 判断記録のルール

すべての判断をレビュー可能な形で記録すること：

1. **判断内容の要約**: どのような判断を下したか
2. **検討した代替案**: 他にどのような選択肢があったか
3. **採用しなかった案とその理由**: なぜその選択肢を採用しなかったか
4. **前提条件・仮定・不確実性**: 判断の前提となる条件や仮定
5. **他エージェントによるレビュー可否**: 他のエージェントがレビューできるか

前提・仮定・不確実性を明示し、仮定を事実のように扱ってはならない。

## プロジェクト概要

このプロジェクトは、Streamlink を使ったライブストリームの自動録画システムです。

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

## 開発手順（概要）

### 1. プロジェクト理解

- プロジェクトの目的と主な機能を理解する
- 技術スタックと依存関係を確認する
- 主要なファイルとディレクトリ構造を把握する

### 2. 依存関係インストール

このプロジェクトは Docker ベースのため、ローカルでの依存関係インストールは不要です。Docker イメージのビルドで完結します。

```bash
# Docker イメージのビルド
docker build -t live-recorder .
```

### 3. 変更実装

- Bash スクリプト（`entrypoint.sh`）の変更
  - ShellCheck に準拠したコードを記述
  - コメントは日本語で記載
  - エラーメッセージは英語で記載

- Dockerfile の変更
  - Hadolint のベストプラクティスに従う
  - ベースイメージのバージョンは `python:3-slim` を維持

- Python 依存関係の変更
  - `requirements.txt` でバージョンを固定
  - Renovate による自動更新を活用

### 4. テストと Lint/Format 実行

```bash
# ShellCheck によるシェルスクリプトの検証
shellcheck entrypoint.sh

# Hadolint による Dockerfile の検証
hadolint Dockerfile

# Docker イメージのビルド確認
docker build -t live-recorder .

# Docker コンテナの起動確認（環境変数を適切に設定）
docker-compose up
```

## セキュリティ / 機密情報

- **認証情報のコミット禁止**: API キーや認証情報を Git にコミットしない
  - 環境変数は `recorder.env` で管理し、`.gitignore` に含まれている
- **ログへの機密情報出力禁止**: ログに個人情報や認証情報を出力しない
- **環境変数の適切な管理**: `TARGET`, `URL`, `STREAMLINK_ARG` などの環境変数を適切に設定

## リポジトリ固有

- このプロジェクトは **Docker での実行を前提** としている。ローカル実行は想定していない。
- 録画ファイルは `/data/recorded/${TARGET}` に保存される。
- 環境変数:
  - 必須: `TARGET`, `URL`
  - オプション: `STREAMLINK_ARG`
- 録画は自動的に再接続し、**5秒間隔で再試行**する。
- Streamlink のバージョンは `requirements.txt` で固定されている。
- **Renovate による依存関係の自動更新**が有効。
  - Renovate が作成した PR に対しては、追加のコミットや変更を行わない。
- **CI/CD パイプライン**は GitHub Actions で実装されている：
  - ShellCheck CI: `*.sh` ファイルの変更時に実行
  - Hadolint CI: `Dockerfile` の変更時に実行
  - Docker CI: イメージのビルドと Docker Hub へのプッシュ
  - Auto-reviewer: PR への自動レビュアー追加
- **Docker Hub へのプッシュ**は、適切な認証情報が設定されている場合のみ実行される。
- **主要ファイル**:
  - `entrypoint.sh`: メインの実行スクリプト（Bash）
  - `Dockerfile`: コンテナイメージのビルド定義
  - `docker-compose.yml`: サービスの起動設定
  - `requirements.txt`: Python 依存関係
  - `recorder.env`: 環境変数設定（Git 管理外）
