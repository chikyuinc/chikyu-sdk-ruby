module Chikyu
  # APIキーのみ必要なAPIを実行する
  class PublicResource < ApiResource
    def initialize(api_key, auth_key)
      @api_key = api_key
      @auth_key = auth_key
    end

    def invoke(resource)
      path = resource[:path]
      data = resource[:data]
      path = path[1..-1] if path.start_with?('/')
      resource_path = "/#{ENV_NAME}/api/v2/public/#{path}"

      params = JSON.generate(data: data)
      res = Faraday.new(url: HOST).post resource_path, params do |req|
        req.headers['Content-Type'] = 'application/json'
        req.headers['x-api-key'] = @api_key
        req.headers['x-auth-key'] = @auth_key
      end

      PublicResource.handle_response res
    end

  end
end