# chikyu-sdk-ruby
## 概要
ちきゅうのWeb APIをRubyから利用するためのライブラリです。

SDKの開発にはRuby 2.2.1を利用しています。

## APIの基本仕様について
こちらのレポジトリをご覧ください

https://github.com/chikyuinc/chikyu-api-specification

## インストール
rubygemsでは公開されていないため、以下の手順でインストールを行ってください。

### bundlerを利用
#### Gemfileに以下の記述を追加
```
gem 'chikyu-sdk', :git => 'https://github.com/chikyuinc/chikyu-sdk-ruby.git', :branch => "master"
```

#### インストール & 確認
```
bundle install
bundle info chikyu-sdk
```

#### 実行
```
bundle exec ruby [該当のファイル].rb
```

### gemコマンドを利用
```
gem install specific_install
gem specific_install -l https://github.com/chikyuinc/chikyu-sdk-ruby.git -b master
```

## SDKを利用する
### テスト段階でのサンプルコード
```test.rb
require 'chikyu/sdk'

# セッションの生成(トークンを事前に生成しておく)
session = Chikyu::Sdk::Session.login(
  token_name: 'token_name',
  login_token: 'login_token',
  login_secret_token: 'login_secret_token'
)

# APIの呼び出し
invoker = Chikyu::Sdk::SecureResource.new session

p invoker.invoke path: '/entity/companies/list', data: {items_per_page: 10, page_index: 0}

```

## 詳細
### class1(APIキーのみで呼び出し可能)
#### APIキーを生成する
```token.rb
require 'chikyu/sdk'

# 後述のclass2 apiを利用し、予めログイン用の「認証トークン」(＊ここで言う「APIキー」とは別)を生成しておく。
session = Chikyu::Sdk::Session.login(
  token_name: 'token_name',
  login_token: 'login_token',
  login_secret_token: 'login_secret_token'
)

invoker = Chikyu::Sdk::SecureResource.new session

# 引数にキー名称と関連付けるロールのIDを指定する。
# 関連付けるロールは、予め作成しておく。
key = invoker.invoke(
  path: '/system/api_auth_key/create',
  data: {
    api_key_name: 'key_name',
    role_id: 1234,
    allowed_hosts: []
})

# 生成したキーをファイルなどに保存しておく。
p key
```

#### 呼び出しを実行する
```invoke_public.rb
require 'chikyu/sdk'

# APIキーを指定してインスタンスを生成
invoker = Chikyu::Sdk::PublicResource.new('api_key', 'auth_key')

# path=APIのパスを指定(詳細については、ページ最下部のリンクを参照)
# data=リクエスト用JSONの「data」フィールド内の項目を指定
res = invoker.invoke path: '/entity/prospects/list', data: {page_index:0, items_per_page:10}

# レスポンス用JSONの「data」フィールド内の項目が返ってくる。
# APIの実行に失敗(エラーが発生 or has_errorがtrue)の場合は例外が発生する。
p res
```

### class2(認証トークンからセッションを生成)
#### 認証トークンを生成する
```create_token.rb
require 'chikyu/sdk'

# ・トークン名称(任意)
# ・ちきゅうのログイン用メールアドレス
# ・ちきゅうのログイン用パスワード
# ・トークンの有効期限(デフォルトでは24時間 - 秒で指定)
token = Chikyu::Sdk::SecurityToken.create 'token_name', 'emaill', 'password', 86400

# トークン情報をファイルなどに保存しておく
p token
```

#### ログインしてセッションを生成する
```create_session.rb
require 'chikyu/sdk'

# 上で生成したトークン情報を保存しておき、展開する
token = {
  token_name: '',
  login_token: '',
  login_secret_token: ''
}

# セッションを生成する
session = Chikyu::Sdk::Session.login token

# セッション情報のオブジェクトをローカル変数などとして保存し、呼び出しに利用する
p session

# セッション情報をテキストに変換する
text = session.to_s

# セッション情報をテキストから復元する
session = Chikyu::Sdk::Session.from_json(text)

# 処理対象の組織を変更する
session.change_organ 1234 # 変更対象の組織IDを指定する

# ログアウトする
session.logout
```


#### 呼び出しを実行する
```invoke_secure.rb

# 上で生成したセッション情報を元に、API呼び出し用のリソースを生成する
invoker = Chikyu::Sdk::SecureResource.new session

# path=APIのパスを指定(詳細については、ページ最下部のリンクを参照)
# data=リクエスト用JSONの「data」フィールド内の項目を指定
res = invoker.invoke path: '/entity/prospects/list', data: {page_index:0, items_per_page:10}

# レスポンス用JSONの「data」フィールド内の項目が返ってくる。
# APIの実行に失敗(エラーが発生 or has_errorがtrue)の場合は例外が発生する。
p res
```


## APIリスト
こちらをご覧ください。

http://dev-docs.chikyu.mobi/

