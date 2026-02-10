# opal-vite-rpg

opal-vite を使用した RPG ゲーム開発プロジェクト

## バージョン

- **Version**: 0.0.0 (開発初期段階)

## 概要

opal-vite を使用した RPG ゲーム開発プロジェクトです。
Ruby/Opal によりオブジェクト指向で構造化された開発を行います。

## 使用技術

- **opal-vite**: Ruby から JavaScript へのコンパイル
- **Vite**: 高速なビルドツール
- **Ruby**: ゲーム開発ロジック

## セットアップ

### 前提条件

- Ruby 3.0 以上
- Node.js 16.0 以上
- npm または yarn

### インストール手順

```bash
# Node の依存パッケージをインストール
npm install
```

**Windows 環境の場合**: 以下のコマンドで Ruby gems をインストールしてください

```bash
gem install opal opal-vite
```

**Linux/Mac 環境の場合**: `bundle install` を実行して依存パッケージをインストールしてください

```bash
bundle install
```

**注記 (Windows 環境)**: 本プロジェクトは `useBundler: false` で設定されています。Windows 環境で bundler を使用するとコンパイルエラーが発生するため、`gem install` で直接 gems をインストールしてください。

## 実行

開発サーバーの起動:

```bash
npm run dev
```

本番用ビルド:

```bash
npm run build
```

## トラブルシューティング

### Windows 環境での Bundler 問題

Windows 環境で `useBundler: true` を使用してビルドして場合、Opal コンパイルエラーが発生することがあります。これは `vite-plugin-opal` が child_process で Ruby を呼び出す際の引数処理に起因します。

**解決方法**: `vite.config.ts` で `useBundler: false` を設定してください。本プロジェクトはすでにこの設定を適用しています。

## プロジェクト構成 (初期構成)

```
.
├── Gemfile              # Ruby 依存パッケージ
├── package.json         # Node 依存パッケージ
├── .gitignore          # Git 除外ファイル
├── README.md           # このファイル
└── (その他の開発ファイル)
```

## ライセンス

MIT

## 作成者

constdrop
