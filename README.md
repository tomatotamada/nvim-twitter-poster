# nvim-twitter-poster 🐦

Neovimから離れることなく、コマンドラインや選択したコードを直接 X (Twitter) に投稿できるプラグインです。

## ✨ 特徴

- **`:Tweet "テキスト"`** : コマンドラインから素早くポスト（API使用）
- **`:TweetSelection`** : Visualモードで選択した範囲をポスト（API使用）
- **`:TweetIntent "テキスト"`** : ブラウザでツイート画面を開く（APIキー不要）
- **`:TweetIntentSelection`** : 選択範囲をブラウザで開く（APIキー不要）

## 📦 前提条件

- Neovim (v0.8.0以上)

**API版 (`:Tweet`, `:TweetSelection`) を使う場合:**
- Python 3.x
- X (Twitter) Developer Account (Free TierでOK)

**Web Intent版 (`:TweetIntent`, `:TweetIntentSelection`) を使う場合:**
- 追加の設定は不要です

## 🚀 インストール方法

### 1. プラグイン設定 (lazy.nvim)

`lazy.nvim` の設定に以下を追加してください。

```lua
return {
  "tomatotamada/nvim-twitter-poster",
  cmd = { "Tweet", "TweetSelection", "TweetIntent", "TweetIntentSelection" },
  config = function()
    require("twitter-post").setup()
  end,
  keys = {
    { "<leader>tw", ":TweetSelection<CR>", mode = "v", desc = "Tweet Selection (API)" },
    { "<leader>ti", ":TweetIntentSelection<CR>", mode = "v", desc = "Tweet Selection (Browser)" },
  }
}
```

### 2. Python環境のセットアップ (API版を使う場合のみ)

> **Note:** `:TweetIntent` / `:TweetIntentSelection` のみ使う場合、この手順は不要です。

インストール後、ターミナルで以下のコマンドを1回だけ実行してください。

```bash
# 1. プラグインのscriptsフォルダへ移動
# (パスはご自身の環境に合わせて調整してください)
cd ~/.local/share/nvim/lazy/nvim-twitter-poster/scripts/

# 2. 仮想環境を作成してライブラリをインストール
python3 -m venv .venv
./.venv/bin/pip install tweepy python-dotenv
```

## 🔑 APIキーの設定 (API版を使う場合のみ)

> **Note:** `:TweetIntent` / `:TweetIntentSelection` のみ使う場合、この手順は不要です。

### 1. Developer Portalでの設定
X Developer Portalで、**App permissions** が **「Read and Write」** になっていることを確認してください。
変更後は必ず **Access Tokenを再生成 (Regenerate)** してください。

### 2. .envファイルの作成
`scripts` フォルダの中に `.env` ファイルを作成します。

**場所:** `nvim-twitter-poster/scripts/.env`

```env
API_KEY=your_api_key
API_SECRET=your_api_secret
ACCESS_TOKEN=your_access_token
ACCESS_SECRET=your_access_secret
```

## 📝 使い方

### API版（完全自動投稿）

```vim
" コマンドラインから投稿
:Tweet 今日はNeovimで開発中！ 🚀

" 選択範囲を投稿 (Visual Mode)
:'<,'>TweetSelection
```

### Web Intent版（APIキー不要）

ブラウザでツイート画面が開き、テキストが入力された状態になります。
最後に「ポスト」ボタンを押して投稿を完了します。

```vim
" コマンドラインから
:TweetIntent 今日はNeovimで開発中！ 🚀

" 選択範囲を投稿 (Visual Mode)
:'<,'>TweetIntentSelection
```

## ❓ トラブルシューティング

**Q. `Error: 403 Forbidden`**

A. 権限不足です。Developer Portalで `App permissions` を **Read and Write** にし、Access Tokenを**再生成**して `.env` に書き直してください。

**Q. `API Keys are missing`**

A. `.env` の場所が間違っています。`scripts` フォルダ内にあるか確認してください。

**Q. `module 'tweepy' not found`**

A. 仮想環境の準備不足です。「インストール方法」の手順2を実行してください。
