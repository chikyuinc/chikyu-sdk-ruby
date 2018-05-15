# Chikyu
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

# 2018/05/14現在、まだ本番環境が未構築であるため、こちらのテスト用の環境名を指定して下さい。
Chikyu::Sdk::ApiConfig.mode = 'devdc'

# セッションの生成
session = Chikyu::Sdk::Session.login(
          token_name: '',
          login_token: '',
          login_secret_token: ''
        )

# APIの呼び出し
invoker = Chikyu::Sdk::SecureResource.new session

p invoker.invoke path: '/entity/companies/list', data: {items_per_page: 10, page_index: 0}
```

## 詳細
### class1(APIキーのみで呼び出し可能)
#### APIトークンを生成する
```token.rb
require 'chikyu/sdk'

# 下記のclass2 apiを利用し、予めトークンを生成しておく。
session = Chikyu::Sdk::Session.login token
key_manager = Chikyu::Sdk::ApiAuthKey.new session

# 引数にキー名称と関連付けるロールのIDを指定する。
# 関連付けるロールは、予め作成しておく。
key = key_manager.create 'test01', 1234

# 生成したキーをファイルなどに保存しておく。
p key

```

#### 呼び出しを実行する
```invoke_public.rb
require 'chikyu/sdk'

invoker = Chikyu::Sdk::PublicResource.new('api_key', 'auth_key')

# path=APIのパスを指定(詳細については、ページ最下部のリンクを参照)
# data=リクエスト用JSONの「data」フィールド内の項目を指定
res = invoker.invoke path: '/some/api' data: {'field1': 'data'}

# レスポンス用JSONの「data」フィールド内の項目が返ってくる。
# APIの実行に失敗(エラーが発生 or has_errorがtrue)の場合は例外が発生する。
p res
```

### class2(APIトークンからセッションを生成)
#### APIトークンを生成する
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
session = Chikyu::Sdk::SecureResource.new token

# セッション情報のオブジェクトをローカル変数などとして保存し、呼び出しに利用する
p session

# セッション情報をテキストに変換する
text = session.to_s

# セッション情報をテキストから復元する
session = Chikyu::Sdk::Session.from_json(text)
```


#### 呼び出しを実行する
```invoke_secure.rb

# 上で生成したセッション情報を元に、API呼び出し用のリソースを生成する
invoker = Chikyu::Sdk::SecureResource.new session

# path=APIのパスを指定(詳細については、ページ最下部のリンクを参照)
# data=リクエスト用JSONの「data」フィールド内の項目を指定
res = invoker.invoke path: '/some/api' data: {'field1': 'data'}

# レスポンス用JSONの「data」フィールド内の項目が返ってくる。
# APIの実行に失敗(エラーが発生 or has_errorがtrue)の場合は例外が発生する。
p res
```


## APIリスト
こちらをご覧ください。

http://dev-docs.chikyu.mobi/

