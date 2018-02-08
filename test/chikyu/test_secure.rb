require 'yaml'
require '../../lib/chikyu'
require '../chikyu/test_config'

config = Chikyu::TestConfig.load

# token_name = config['user']['token_name']
# token = Chikyu::SecurityToken.create token_name, config['user']['email'], config['user']['password']
# token['token_name'] = token_name

token = {
  token_name: config['token']['token_name'],
  login_token: config['token']['login_token'],
  login_secret_token: config['token']['login_secret_token']
}

session = Chikyu::Session.new.login token

session.change_organ 1460

resource = Chikyu::SecureResource.new(session)

items = resource.invoke(path: '/entity/prospects/list', data: { items_per_page: 10, page_index: 0 })

puts JSON.pretty_generate(items)

session.logout
