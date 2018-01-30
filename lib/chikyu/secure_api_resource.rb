module Chikyu
  # 認証の必要なAPIを実行する
  class SecureResource
    def initialize(session)
      @session = session
    end

    def invoke(resource)
      path = resource[:path]
      data = resource[:data]
      path = path[1..-1] if path.start_with?('/')
      resource_path = "/#{ENV_NAME}/api/v2/secure/#{path}"

      session_id = @session.chikyu_session_id
      api_key = @session.aws_api_key
      credential = @session.aws_credential

      conn = connection(credential)
      res = send(resource_path, session_id, api_key, data, conn)

      if res.success?
        data = res.body

        raise ApiExecuteError.new(path, params, data['message']) if data['has_error']

        return data
      end

      raise HttpError.new('リクエストの送信に失敗しました', res.status, res.body)
    end

    private def send(resource_path, session_id, api_key, data, conn)
      conn.post(resource_path, JSON.generate(session_id: session_id, data: data)) do |req|
        req.headers['Content-Type'] = 'application/json'
        req.headers['x-api-key'] = api_key
      end
    end

    private def connection(credential)
      Faraday.new(url: HOST) do |faraday|
        faraday.request :aws_signers_v4,
                        credentials: credential,
                        service_name: 'execute-api',
                        region: 'ap-northeast-1'

        faraday.response :json, content_type: /\bjson\b/
        faraday.response :raise_error
        # デバッグ出力
        faraday.response :logger if WITH_DEBUG

        faraday.adapter Faraday.default_adapter
      end
    end
  end
end