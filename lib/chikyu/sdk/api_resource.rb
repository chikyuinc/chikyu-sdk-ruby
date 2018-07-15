module Chikyu::Sdk
  # API抽象クラス
  class ApiResource
    def self.handle_response(path, params, res)
      if res.success?
        body = res.body
        data = body.instance_of?(String) ? JSON.parse(body, symbolize_names: true) : body

        if data[:has_error]
          raise ApiExecuteError, "APIの実行に失敗: message=#{data[:message]} / path=#{path} / params=#{params}}"
        end

        return data[:data]
      else
        p "response_code: #{res.status}"
        p "response_body: #{res.body}"
      end

      raise HttpError, "リクエストの送信に失敗しました: code=#{res.status} / body=#{res.body}"
    end

    def self.build_url(api_class, api_path, with_host=true)
      res = with_host ? build_host : ''

      path = api_path.start_with?('/') ? api_path[1..-1] : api_path
      if ApiConfig.mode == 'prod'
        return "#{res}/v2/#{api_class}/#{path}"
      end

      env = ApiConfig.env_name.empty? ? '' : "/#{ApiConfig.env_name}"
      "#{res}#{env}/api/v2/#{api_class}/#{path}"
    end

    def self.build_host
      "#{ApiConfig.protocol}://#{ApiConfig.host}"
    end
  end

end