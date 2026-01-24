# nvim-twitter-poster 🐦

Neovimの中から直接Twitter (X) に投稿するためのシンプルなプラグインです。
コマンド一発での投稿や、Visualモードで選択したコード/テキストの投稿が可能です。

## ✨ Features

- `:Tweet "Hello World"` : コマンドラインから投稿
- `:TweetSelection` : 選択した範囲（Visual Mode）を投稿

## 📦 Requirements

- Python 3.x
- Neovim
- X (Twitter) Developer Account (Free Tier OK)

Limitations
API制限: X (Twitter) API Free Tierを使用している場合、月間の投稿数（通常500件）やAPIレートリミットの制限があります。

テキストのみ: 現状はテキストの投稿のみ対応しており、画像のアップロードには対応していません。

## 🚀 Installation

### 1. Pythonライブラリのインストール
このプラグインはPythonを使用します。

```bash
pip install tweepy python-dotenv

### 2. envファイルに自分のAPIキーを入れる
セキュリティのため、APIキーはソースコードには書かず、環境変数ファイル（.env）で管理します。 プラグイン内の scripts ディレクトリに .env ファイルを作成し、キーを入力してください。
