module Chikyu
  # 認証不要のAPIを実行する
  class OpenResource < ApiResource
    def self.invoke(resource)
      path = resource[:path]
      data = resource[:data]

      path = path[1..-1] if path.start_with?('/')

      url = "#{HOST}/#{ENV_NAME}/api/v2/open/#{path}"
      params = JSON.generate(data: data)
      res = Faraday.post(url,
                         params,
                         request: 'json',
                         response: 'json',
                         content_type: 'application/json')

      OpenResource.handle_response(res)
    end
  end
end
