# GitHub Copilot Code Review Instructions

このファイルは GitHub Copilot のコードレビュー機能向けの指示です。レビュー時に重点確認すべき点と、フラグすべきでない既知パターンを定義します。

## プロジェクト前提

- Streamlink を使ったライブストリームの自動録画システム。Docker 実行専用。
- 構成要素は 3 つのみ: `entrypoint.sh`（Bash・録画の本体ロジック）、`Dockerfile`、`docker-compose.yml`。
- 自動テストは無し。品質は CI の静的解析（ShellCheck / Hadolint）で担保する。

## レビューで重点確認する点

- **環境変数の検証**: `entrypoint.sh` は処理開始前に必須環境変数（`TARGET`, `URL`）の存在チェックを行う。新規に必須環境変数を追加する変更では、同様の未設定チェックとエラー終了が追加されているか確認する。
- **エラーハンドリング**: 録画ループの失敗時挙動（再接続・リトライ）を壊していないか。無限ループから抜ける条件を不用意に追加していないか。
- **ShellCheck 準拠**: `*.sh` の変更は ShellCheck 準拠が必須（CI で強制）。警告を `# shellcheck disable=...` で抑止する変更には正当な理由が必要。理由なき新規 disable コメントはフラグする。
- **Hadolint 準拠**: `Dockerfile` の変更は Hadolint のベストプラクティスに従う（CI で強制）。
- **セキュリティ**: 認証情報・URL・個人情報をログや標準出力へ出していないか。環境変数の値をエコーしていないか。`recorder.env` などの機密ファイルをコミットに含めていないか。

## コーディング規約

- エラーメッセージ・コードコメントは英語（既存コードに準拠）。
- コミットは [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/)、`<description>` は日本語。
- 日本語と英数字の間には半角スペースを入れる。

## フラグすべきでない既知パターン（誤検知防止）

- **`while :; do ... sleep 5; done` の無限ループ**: 切断時の自動再接続のための意図的な設計。「無限ループ」「終了条件が無い」として指摘しない。
- **`streamlink ... ${STREAMLINK_ARG} ...` 直前の `# shellcheck disable=SC2086`**: `STREAMLINK_ARG` を複数引数として意図的に単語分割している。SC2086 の指摘は不要。
- **`Dockerfile` の `python:3-slim`（ダイジェスト・パッチ版未固定）**: 常に最新の Python 3 slim を追随する方針で意図的に固定していない。「ベースイメージのバージョン未固定」として指摘しない。
- **`Dockerfile` の `# hadolint ignore=DL3008`（apt パッケージのバージョン未固定）**: 意図的な ignore。指摘しない。
- **Streamlink のバージョン**: `requirements.txt` で固定し、更新は Renovate に委ねる。バージョン番号自体の値についての指摘は不要。
