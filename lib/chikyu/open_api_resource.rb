module Chikyu
  # 認証不要のAPIを実行する
  class OpenResource < ApiResource
    def self.invoke(resource)
      path = resource[:path]
      data = resource[:data]

      url = OpenResource.build_url('open', path)
      params = JSON.generate(data: data)
      res = Faraday.post(url,
                         params,
                         request: 'json',
                         response: 'json',
                         content_type: 'application/json')

      OpenResource.handle_response url, params, res
    end
  end
end
