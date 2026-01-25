# GitHub Copilot Instructions

## プロジェクト概要

- 目的: Streamlink を使ったライブストリームの自動録画
- 主な機能: ライブストリーム URL を監視し、放送を自動的に録画し、切断時には自動的に再接続
- 対象ユーザー: Docker を使用するライブストリーム録画ユーザー

## 共通ルール

- 会話は日本語で行う。
- PR とコミットは [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/) に従う。
  - `<description>` は日本語で記載する。
  - 例: `feat: 自動録画機能を追加`
- 日本語と英数字の間には半角スペースを入れる。

## 技術スタック

- 言語: Bash (Shell scripting)
- ランタイム: Python 3 (slim)
- 主要な依存関係: Streamlink v8.1.2
- コンテナプラットフォーム: Docker & Docker Compose
- パッケージマネージャー: pip (Python)

## コーディング規約

- フォーマット: ShellCheck に準拠
- Bash スクリプトは ShellCheck で検証
- Dockerfile は Hadolint で検証
- エラーメッセージは英語で記載
- コメントは英語で記載（既存コードに準拠）

## 開発コマンド

```bash
# Docker イメージのビルド
docker build -t live-recorder .

# Docker Compose での起動
docker-compose up -d

# ログの確認
docker-compose logs -f

# コンテナの停止
docker-compose down

# ShellCheck によるシェルスクリプトの検証
shellcheck entrypoint.sh

# Hadolint による Dockerfile の検証
hadolint Dockerfile
```

## テスト方針

- テストフレームワーク: なし（自動テストは実装されていない）
- 品質保証: CI/CD パイプライン（ShellCheck, Hadolint）による静的解析
- 動作確認: Docker コンテナを起動し、実際のストリーム URL で録画が正常に動作することを確認

## セキュリティ / 機密情報

- 環境変数は `recorder.env` で管理し、Git にコミットしない。
- API キーや認証情報をログに出力しない。
- `recorder.env` は `.gitignore` に含まれている。

## ドキュメント更新

- `README.md`: 機能追加時や使用方法の変更時
- `requirements.txt`: Python 依存関係の変更時
- `Dockerfile`: ベースイメージやインストール手順の変更時
- `docker-compose.yml`: サービス設定の変更時

## リポジトリ固有

- このプロジェクトは Docker での実行を前提としている。
- 録画ファイルは `/data/${TARGET}` に保存される。
- 環境変数 `TARGET`, `URL` は必須。`STREAMLINK_ARG` はオプション。
- 録画は自動的に再接続し、5秒間隔で再試行する。
- Renovate による依存関係の自動更新が有効。
- Renovate が作成した PR に対しては、追加のコミットや変更を行わない。
