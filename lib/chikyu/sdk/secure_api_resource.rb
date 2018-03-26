module Chikyu::Sdk
  # ログイン認証の必要なAPIを実行する
  class SecureResource < ApiResource
    def initialize(session)
      @session = session
    end

    def invoke(resource)
      path = resource[:path]
      data = resource[:data]
      resource_path = SecureResource.build_url('secure', path, false)

      conn = connection
      res = send resource_path, data, conn

      SecureResource.handle_response PublicResource.build_host + resource_path, data, res
    end

    private

    def send(resource_path, data, conn)
      params = {
        session_id: @session.session_id,
        data: data
      }
      params[:identity_id] = @session.aws_identity_id if ApiConfig.mode == 'local'

      conn.post resource_path, JSON.generate(params) do |req|
        req.headers['Content-Type'] = 'application/json'
        req.headers['x-api-key'] = @session.aws_api_key
      end
    end

    def connection
      Faraday.new(url: SecureResource.build_host) do |faraday|
        faraday.request :aws_signers_v4,
                        credentials: @session.aws_credential,
                        service_name: ApiConfig.aws_api_gw_service_name,
                        region: ApiConfig.aws_region

        faraday.response :json, parser_options: { symbolize_names: true }, content_type: /\bjson\b/
        # faraday.response :raise_error
        faraday.adapter Faraday.default_adapter

        # デバッグ出力
        faraday.response :logger if ApiConfig.with_debug
      end
    end
  end
end