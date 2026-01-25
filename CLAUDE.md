# Claude Code Instructions

## 目的

このファイルは、Claude Code がこのプロジェクトで作業する際の方針とルールを定義します。

## 判断記録のルール

Claude Code は、すべての判断をレビュー可能な形で記録すること：

1. 判断内容の要約を記載する
2. 検討した代替案を列挙する
3. 採用しなかった案とその理由を明記する
4. 前提条件・仮定・不確実性を明示する
5. 他エージェントによるレビュー可否を示す

前提・仮定・不確実性を明示し、仮定を事実のように扱ってはならない。

## プロジェクト概要

- 目的: Streamlink を使ったライブストリームの自動録画システム
- 主な機能:
  - ライブストリーム URL の監視と自動録画
  - 切断時の自動再接続（5秒間隔）
  - Docker コンテナによる実行環境の提供
  - ボリュームマウントによる録画ファイルの永続化

## 重要ルール

- 会話言語: 日本語
- コミット規約: [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/)
  - `<description>` は日本語で記載
  - 例: `feat: 録画品質オプションを追加`
- コメント言語: 英語（既存コードに準拠）
- エラーメッセージ言語: 英語
- 日本語と英数字の間には半角スペースを挿入

## 環境のルール

- ブランチ命名: [Conventional Branch](https://conventional-branch.github.io) に従う
  - `<type>` は短縮形（feat, fix, docs）を使用
  - 例: `feat/add-quality-option`
- GitHub リポジトリ調査方法: テンポラリディレクトリに git clone して調査
- Renovate PR の扱い: Renovate が作成した既存のプルリクエストに対して、追加コミットや更新を行ってはならない

## Git Worktree

このプロジェクトでは Git Worktree を使用していません。標準的な Git ワークフローを使用してください。

## コード改修時のルール

- Bash スクリプト:
  - ShellCheck に準拠したコードを記述
  - エラーメッセージは英語で記載
  - コメントは英語で記載（既存コードに準拠）
  - 既存のエラーメッセージに絵文字がある場合は、統一して使用
- Dockerfile:
  - Hadolint のベストプラクティスに従う
  - ベースイメージのバージョンは明示的に指定しない（`python:3-slim` を維持）
- Python 依存関係:
  - `requirements.txt` でバージョンを固定
  - Renovate による自動更新を活用

## 相談ルール

他の AI エージェントに相談することができます：

- **Codex CLI** (`ask-codex`):
  - Bash スクリプトの実装レビュー
  - シェルスクリプトのベストプラクティス確認
  - セキュリティ上の問題の検証
  - 既存コードとの整合性確認

- **Gemini CLI** (`ask-gemini`):
  - Streamlink の最新仕様確認
  - Docker の最新ベストプラクティス確認
  - Python パッケージの最新情報確認
  - 外部依存関係の制約確認

他エージェントが指摘・異議を提示した場合、Claude Code は必ず以下のいずれかを行う。黙殺・無言での不採用は禁止する：

- 指摘を受け入れ、判断を修正する
- 指摘を退け、その理由を明示する

以下は必ず実施すること：

- 他エージェントの提案を鵜呑みにせず、その根拠や理由を理解する
- 自身の分析結果と他エージェントの意見が異なる場合は、双方の視点を比較検討する
- 最終的な判断は、両者の意見を総合的に評価した上で、自身で下す

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

## アーキテクチャと主要ファイル

### アーキテクチャサマリー

```
Docker Container
├── Python 3 Runtime (slim)
├── Streamlink Library (v8.1.2)
└── Bash Entrypoint Script
    ├── 環境変数の検証 (TARGET, URL)
    ├── ディレクトリの作成
    └── 無限ループによる録画と再接続:
        └── 実行: streamlink --default-stream best -o {OUTPUT}/{title}.mp4 {ARGS} {URL}
        └── 待機: 5秒
        └── 失敗時に再試行
```

### 主要ディレクトリとファイル

- `entrypoint.sh`: メインの実行スクリプト（Bash）
- `Dockerfile`: コンテナイメージのビルド定義
- `docker-compose.yml`: サービスの起動設定
- `requirements.txt`: Python 依存関係（streamlink==8.1.2）
- `recorder.env`: 環境変数設定（Git 管理外）
- `.github/workflows/`: CI/CD パイプライン定義
  - `shell-ci.yml`: ShellCheck による検証
  - `hadolint-ci.yml`: Hadolint による検証
  - `docker.yml`: Docker イメージのビルドとプッシュ
  - `add-reviewer.yml`: PR への自動レビュアー追加

## 実装パターン

### 推奨パターン

- ShellCheck の警告を可能な限り修正する（正当な理由がある場合のみ disable コメントを使用）
- Hadolint のベストプラクティスに従う
- 環境変数の検証を最初に実施
- エラーハンドリングを適切に実装
- ログ出力は標準出力/標準エラー出力を使用

### 非推奨パターン

- 理由なく ShellCheck の警告を無効化するコメント（`# shellcheck disable=...`）を使用すること
- ハードコードされた値（環境変数を使用すべき）
- エラーハンドリングの欠如
- センシティブな情報のログ出力

## テスト

### テスト方針

- 自動テストは実装されていない
- CI/CD による静的解析で品質を担保
  - ShellCheck: Bash スクリプトの検証
  - Hadolint: Dockerfile の検証
- 動作確認は Docker コンテナを起動して実施

### テスト追加の条件

新しい機能を追加する場合は、以下を確認：

1. ShellCheck で警告が出ないこと
2. Hadolint で警告が出ないこと
3. 実際の Docker コンテナで動作確認すること
4. 環境変数が正しく渡されることを確認すること
5. 録画ファイルが正しく保存されることを確認すること

## ドキュメント更新ルール

### 更新対象

- `README.md`: 機能追加時や使用方法の変更時
- `requirements.txt`: Python 依存関係の変更時
- `Dockerfile`: ベースイメージやインストール手順の変更時
- `docker-compose.yml`: サービス設定の変更時
- このファイル（`CLAUDE.md`）: プロジェクトルールや方針の変更時

### 更新タイミング

- 機能追加時: PR 作成前に更新
- バグ修正時: 必要に応じて更新
- 依存関係更新時: 必要に応じて更新

## 作業チェックリスト

### 新規改修時

1. プロジェクトについて詳細に探索し理解すること
2. 作業を行うブランチが適切であること。すでに PR を提出しクローズされたブランチでないこと
3. 最新のリモートブランチに基づいた新規ブランチであること
4. PR がクローズされ、不要となったブランチは削除されていること
5. Docker イメージがビルド可能であることを確認すること（`docker build -t live-recorder .`）

### コミット・プッシュする前

1. コミットメッセージが Conventional Commits に従っていること。`<description>` は日本語で記載
2. コミット内容にセンシティブな情報が含まれていないこと
3. Lint / Format エラーが発生しないこと
   - ShellCheck: `shellcheck entrypoint.sh`
   - Hadolint: `hadolint Dockerfile`
4. 動作確認を行い、期待通り動作すること
   - Docker イメージのビルド成功
   - コンテナの起動成功（環境変数を適切に設定）

### PR 作成前

1. プルリクエストの作成をユーザーから依頼されていること
2. コミット内容にセンシティブな情報が含まれていないこと
3. コンフリクトする恐れが無いこと

### PR 作成後

1. コンフリクトが発生していないこと
2. PR 本文の内容は、ブランチの現在の状態を、今までのこの PR での更新履歴を含むことなく、最新の状態のみ、漏れなく日本語で記載されていること。この PR を見たユーザーが、最終的にどのような変更を含む PR なのかをわかりやすく、細かく記載されていること
3. `gh pr checks <PR ID> --watch` で GitHub Actions CI を待ち、その結果がエラーとなっていないこと。成功している場合でも、ログを確認し、誤って成功扱いになっていないこと
4. `request-review-copilot` コマンドが存在する場合、`request-review-copilot https://github.com/$OWNER/$REPO/pull/$PR_NUMBER` で GitHub Copilot へレビューを依頼すること
5. 10分以内に投稿される GitHub Copilot レビューへの対応を行うこと。対応したら、レビューコメントそれぞれに対して返信を行うこと
6. `/code-review:code-review` によるコードレビューを実施したこと。コードレビュー内容に対しては、**スコアが 50 以上の指摘事項** に対して対応してください

## リポジトリ固有

- このプロジェクトは Docker での実行を前提としている。ローカル実行は想定していない。
- 録画ファイルは `/data/${TARGET}` に保存される。
- 環境変数は必須（`TARGET`, `URL`）とオプション（`STREAMLINK_ARG`）がある。
- 録画は自動的に再接続し、5秒間隔で再試行する。
- Streamlink のバージョンは `requirements.txt` で固定されている。
- Renovate による依存関係の自動更新が有効。
- CI/CD パイプラインは GitHub Actions で実装されている：
  - ShellCheck CI: `*.sh` ファイルの変更時に実行
  - Hadolint CI: `Dockerfile` の変更時に実行
  - Docker CI: イメージのビルドと Docker Hub へのプッシュ
- Docker Hub へのプッシュは、適切な認証情報が設定されている場合のみ実行される。
