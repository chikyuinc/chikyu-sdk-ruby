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
```
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

#### 呼び出しを実行する

### class2(APIトークンからセッションを生成)
#### APIトークンを生成する

#### ログインしてセッションを生成する


#### 呼び出しを実行する


## APIリスト
こちらをご覧ください。

http://dev-docs.chikyu.mobi/

