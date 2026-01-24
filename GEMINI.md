# GEMINI.md

## 目的
- Gemini CLI 向けのコンテキストと作業方針を定義する。

## 出力スタイル
- 言語: 日本語
- トーン: 簡潔で事実ベース
- 形式: Markdown

## 共通ルール
- 会話は日本語で行う。
- PR とコミットは Conventional Commits に従う。
- PR タイトルとコミット本文の言語: PR タイトルは Conventional Commits 形式（英語推奨）。PR 本文は日本語。コミットは Conventional Commits 形式（description は日本語）。
- 日本語と英数字の間には半角スペースを入れる。

## プロジェクト概要
Docker-based tool to record and download live streams using streamlink.

### 技術スタック
- **言語**: Python
- **フレームワーク**: streamlink
- **パッケージマネージャー**: pip
- **主要な依存関係**:
  - streamlink==8.1.2

## コーディング規約
- フォーマット: 既存設定（ESLint / Prettier / formatter）に従う。
- 命名規則: 既存のコード規約に従う。
- コメント言語: 日本語
- エラーメッセージ: 英語

### 開発コマンド
```bash
# install
docker-compose up --build

# dev
Docker container execution

# build
docker build

# test
None

# lint
None

```

## 注意事項
- 認証情報やトークンはコミットしない。
- ログに機密情報を出力しない。
- 既存のプロジェクトルールがある場合はそれを優先する。

## リポジトリ固有
- **docker_support**: True
- **base_image**: python:3-slim
- **streaming_framework**: streamlink v8.1.2
- **deployment**: Docker Compose only
- **entry_point**: Shell script (entrypoint.sh)
- **disclaimer**: Developer not responsible for user issues