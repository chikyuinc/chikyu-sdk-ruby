require 'yaml'
require '../../lib/chikyu/sdk'
require '../chikyu_sdk/test_config'

config = Chikyu::Sdk::TestConfig.load 'devdc'

invoker = Chikyu::Sdk::PublicResource.new(config['api_key']['api_key'], config['api_key']['auth_key'])

res = invoker.invoke(path: '/entity/prospects/save',
                     data: {
                       key: '',
                       fields: {
                         city: '東京'
                       },
                       options: {
                         key_search_option: {
                           input_method: 'by_field_value',
                           input_field_name: 'email'
                         }
                       }
                     })

p res

