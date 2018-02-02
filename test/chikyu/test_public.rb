require 'yaml'
require '../../lib/chikyu'

config = YAML.load_file '../config.yml'

invoker = Chikyu::PublicResource.new(config['api_key']['api_key'], config['api_key']['auth_key'])

res = invoker.invoke(path: '/entity/prospects/create',
                     data: { fields: {first_name: 'taro', last_name: 'test' } })

p res

