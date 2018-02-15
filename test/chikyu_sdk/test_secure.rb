require 'yaml'
require '../../lib/chikyu/sdk'
require '../chikyu_sdk/test_config'

config = Chikyu::Sdk::TestConfig.load

token = {
  token_name: config['token']['token_name'],
  login_token: config['token']['login_token'],
  login_secret_token: config['token']['login_secret_token']
}

session = Chikyu::Sdk::Session.login token

session.change_organ 1
#
resource = Chikyu::Sdk::SecureResource.new(session)
#
# items = resource.invoke(path: '/entity/prospects/list', data: { items_per_page: 10, page_index: 0 })

print "ログインしました"

items = resource.invoke(path: '/entity/business_discussions/aggregate', data: {
  group_list: [{field_name: 'situation_div', grouping_type: ''}],
  target_list: [{field_name: '__count__', aggregation_type: ''}]
})
items['data']['aggregation_result'].each {|data|
  p "#{data['series_name']}:#{data['values'][0]['value']}"
}
p "********************"

items = resource.invoke(path: '/entity/business_discussions/aggregate', data: {
    group_list: [{field_name: 'situation_div', grouping_type: ''}],
    target_list: [{field_name: 'amount', aggregation_type: 'sum'}]
})
items['data']['aggregation_result'].each {|data|
  p "#{data['series_name']}:#{data['values'][0]['value']}"
}


# puts JSON.pretty_generate(items)

# items = resource.invoke(path: '/entity/prospects/search_definitions/list', data: {})


# session.logout
