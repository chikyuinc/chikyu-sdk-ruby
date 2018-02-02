module Chikyu
  # ログイン認証の必要なAPIを実行する
  class SecureResource < ApiResource
    def initialize(session)
      @session = session
    end

    def invoke(resource)
      path = resource[:path]
      data = resource[:data]
      path = path[1..-1] if path.start_with?('/')
      resource_path = "/#{ENV_NAME}/api/v2/secure/#{path}"

      conn = connection
      res = send resource_path, data, conn

      SecureResource.handle_response res
    end

    private

    def send(resource_path, data, conn)
      conn.post resource_path, JSON.generate(session_id: @session.chikyu_session_id, data: data) do |req|
        req.headers['Content-Type'] = 'application/json'
        req.headers['x-api-key'] = @session.aws_api_key
      end
    end

    def connection
      Faraday.new(url: HOST) do |faraday|
        faraday.request :aws_signers_v4,
                        credentials: @session.aws_credential,
                        service_name: AWS_API_GW_SERVICE_NAME,
                        region: AWS_REGION

        faraday.response :json, content_type: /\bjson\b/
        faraday.response :raise_error
        faraday.adapter Faraday.default_adapter

        # デバッグ出力
        faraday.response :logger if WITH_DEBUG
      end
    end
  end
end