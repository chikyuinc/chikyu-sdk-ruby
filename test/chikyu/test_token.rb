require 'yaml'
require '../../lib/chikyu'
require '../chikyu/test_config'

config = Chikyu::TestConfig.load

token_name = config['user']['token_name']

duration = 86_400 * 30 * 12 * 10
token = Chikyu::SecurityToken.create token_name, config['user']['email'], config['user']['password'], duration
token['token_name'] = token_name

p token
