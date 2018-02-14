require 'yaml'
require '../../lib/chikyu-sdk'
require '../chikyu-sdk/test_config'

config = ChikyuSdk::TestConfig.load

# token_name = config['user']['token_name']
# token = Chikyu::SecurityToken.create token_name, config['user']['email'], config['user']['password']
# token['token_name'] = token_name

token = {
    token_name: config['token']['token_name'],
    login_token: config['token']['login_token'],
    login_secret_token: config['token']['login_secret_token']
}

session = ChikyuSdk::Session.new.login token

key_manager = ChikyuSdk::ApiAuthKey.new(session)

p key_manager.create 'test01'

