module Chikyu::Sdk
  # セキュリティトークンを元にログイン / ログアウトを行う
  class Session
    attr_reader :session_id
    attr_reader :user
    attr_reader :aws_api_key
    attr_reader :aws_credential
    attr_reader :aws_identity_id

    def self.login(resource)
      s = new
      token_name = resource[:token_name] ? resource[:token_name] : resource['token_name']
      login_token = resource[:login_token] ? resource[:login_token] : resource['login_token']
      login_secret_token =
        resource[:login_secret_token] ? resource[:login_secret_token] : resource['login_secret_token']
      s.__send__(:__login_invoke, token_name, login_token, login_secret_token)
    end

    def change_organ(organ_id)
      result = SecureResource.new(self).invoke(path: '/session/organ/change', data: {target_organ_id: organ_id})
      aws_api_key = result[:api_key]
      user = result[:user]
      if aws_api_key.nil? || aws_api_key.empty? || user.nil? || user.empty?
        raise ApiExecuteError('組織IDの変更に失敗しました')
      end
      @aws_api_key = aws_api_key
      @user = user
    end

    def logout
      SecureResource.new(self).invoke(path: '/session/logout', data: {})
      @session_id = nil
      @aws_api_key = nil
      @aws_credential = nil
      @user = nil
    end

    def to_hash
      {
        session_id: @session_id,
        user: @user,
        aws_api_key: @aws_api_key,
        aws_credential: {
          access_key_id: @aws_credential.access_key_id,
          secret_access_key: @aws_credential.secret_access_key,
          session_token: @aws_credential.session_token,
          duration_seconds: 43200
        },
        aws_identity_id: @aws_identity_id,
      }
    end

    def to_json
      JSON.generate(to_hash)
    end

    def self.from_json(json_str)
      s = new
      data = JSON.parse(json_str, symbolize_names: true)
      s.__send__(:__set_parameters, data)
    end

    def self.from_hash(data)
      s = new
      s.__send__(:__set_parameters, data)
    end

    def to_s
      to_json
    end

    private

    def __set_parameters(data)
      @session_id = data[:session_id]
      @user = data[:user]
      @aws_identity_id = data[:aws_identity_id]
      @aws_api_key = data[:aws_api_key]
      @aws_credential = Aws::Credentials.new(data[:aws_credential][:access_key_id],
                                             data[:aws_credential][:secret_access_key],
                                             data[:aws_credential][:session_token])
      self
    end

    def __login_invoke(token_name, login_token, login_secret_token)
      tokens = OpenResource.invoke(path: '/session/login',
                                   data: {
                                     token_name: token_name,
                                     login_token: login_token,
                                     login_secret_token: login_secret_token
                                   })

      @session_id = tokens[:session_id]
      @aws_identity_id = tokens[:cognito_identity_id]
      @aws_api_key = tokens[:api_key]
      @aws_credential = __create_aws_token(tokens)
      @user = tokens[:user]

      self
    end

    def __create_aws_token(tokens)
      cognito_token = tokens[:cognito_token]
      r = Aws::STS::Client.new.assume_role_with_web_identity(role_arn: ApiConfig.aws_role_arn,
                                                             web_identity_token: cognito_token,
                                                             role_session_name: ApiConfig.aws_api_gw_service_name)

      credential = Aws::Credentials.new(r.credentials.access_key_id,
                                        r.credentials.secret_access_key,
                                        r.credentials.session_token)

      Aws.config[:credentials] = credential

      credential
    end
  end
end