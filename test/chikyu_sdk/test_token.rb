require 'yaml'
require '../../lib/chikyu/sdk'
require '../chikyu_sdk/test_config'

config = Chikyu::Sdk::TestConfig.load 'local'

token_name = config['user']['token_name']

duration = 86_400 * 30 * 12 * 10
token = Chikyu::Sdk::SecurityToken.create token_name, config['user']['email'], config['user']['password'], duration
token[:token_name] = token_name

p token
