require 'yaml'
require '../../lib/chikyu/sdk'
require '../chikyu_sdk/test_config'

config = Chikyu::Sdk::TestConfig.load 'local'

invoker = Chikyu::Sdk::PublicResource.new(config['api_key']['api_key'], config['api_key']['auth_key'])

res = invoker.invoke(path: '/entity/prospects/create',
                     data: { fields: {first_name: 'taro', last_name: 'test' } })

p res

