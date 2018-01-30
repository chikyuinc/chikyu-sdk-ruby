module Chikyu
  # 認証不要のAPIを実行する
  class OpenResource
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

      if res.success?
        data = JSON.parse(res.body)

        raise ApiExecuteError.new(path, params, data['message']) if data['has_error']

        return data
      end

      raise HttpError.new('リクエストの送信に失敗しました', res.status, res.body)
    end
  end
end
