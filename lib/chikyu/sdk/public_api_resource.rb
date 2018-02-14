module Chikyu::Sdk
  # APIキーのみ必要なAPIを実行する
  class PublicResource < ApiResource
    def initialize(api_key, auth_key)
      @api_key = api_key
      @auth_key = auth_key
    end

    def invoke(resource)
      path = resource[:path]
      data = resource[:data]
      resource_path = PublicResource.build_url('public', path, false)

      p resource_path
      p PublicResource.build_host

      params = JSON.generate(data: data)
      res = Faraday.new(url: PublicResource.build_host).post resource_path, params do |req|
        req.headers['Content-Type'] = 'application/json'
        req.headers['x-api-key'] = @api_key
        req.headers['x-auth-key'] = @auth_key
      end

      PublicResource.handle_response PublicResource.build_host + resource_path, params, res
    end

  end
end