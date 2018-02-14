module ChikyuSdk
  # API抽象クラス
  class ApiResource
    def self.handle_response(path, params, res)
      if res.success?
        body = res.body
        data = body.instance_of?(String) ? JSON.parse(body) : body

        raise ApiExecuteError.new(path, params, data['message']) if data['has_error']

        return data
      else
        p "response_code: #{res.status}"
        body = JSON.parse(res.body)
        p "response_body: #{body}"
      end

      raise HttpError.new('リクエストの送信に失敗しました', res.status, res.body)
    end

    def self.build_url(api_class, api_path, with_host=true)
      res = with_host ? build_host : ''
      env = Config.env_name.empty? ? '' : "/#{Config.env_name}"
      path = api_path.start_with?('/') ? api_path[1..-1] : api_path
      "#{res}#{env}/api/v2/#{api_class}/#{path}"
    end

    def self.build_host
      "#{Config.protocol}://#{Config.host}"
    end
  end

end