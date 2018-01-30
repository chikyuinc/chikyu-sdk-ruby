require 'yaml'
require '../../lib/chikyu'

config = YAML.load_file '../config.yml'

# token_name = config['user']['token_name']
# token = Chikyu::SecurityToken.create token_name, config['user']['email'], config['user']['password']
# token['token_name'] = token_name

token = {
    token_name: config['token']['token_name'],
    login_token: config['token']['login_token'],
    login_secret_token: config['token']['login_secret_token']
}

session = Chikyu::Session.new.login token

invoker = Chikyu::SecureResource.new(session)

items = invoker.invoke(path: '/entity/prospects/list', data:{items_per_page: 10, page_index: 0 })

p items

session.logout
