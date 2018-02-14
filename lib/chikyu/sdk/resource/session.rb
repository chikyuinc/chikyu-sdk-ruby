module ChikyuSdk
  # セキュリティトークンを元にログイン / ログアウトを行う
  class Session
    attr_reader :chikyu_session_id
    attr_reader :aws_api_key
    attr_reader :aws_credential
    attr_reader :aws_identity_id

    def login(resource)
      token_name = resource[:token_name] ? resource[:token_name] : resource['token_name']
      login_token = resource[:login_token] ? resource[:login_token] : resource['login_token']
      login_secret_token =
        resource[:login_secret_token] ? resource[:login_secret_token] : resource['login_secret_token']

      tokens = __login(token_name, login_token, login_secret_token)

      @chikyu_session_id = tokens['data']['session_id']
      @aws_identity_id = tokens['data']['cognito_identity_id']
      @aws_api_key = tokens['data']['api_key']
      @aws_credential = __create_aws_token(tokens)

      self
    end

    def change_organ(organ_id)
      result = SecureResource.new(self).invoke(path: '/session/organ/change', data: {target_organ_id: organ_id})
      aws_api_key = result['data']['api_key']
      if aws_api_key.nil? || aws_api_key.empty?
        raise ApiExecuteError('組織IDの変更に失敗しました')
      end
      @aws_api_key = aws_api_key
    end

    def logout
      SecureResource.new(self).invoke(path: '/session/logout', data: {})
      @chikyu_session_id = nil
      @aws_api_key = nil
      @aws_credential = nil
    end

    private

    def __login(token_name, login_token, login_secret_token)
      OpenResource.invoke(path: '/session/login',
                          data: {token_name: token_name,
                                 login_token: login_token,
                                 login_secret_token: login_secret_token})
    end

    def __create_aws_token(tokens)
      cognito_token = tokens['data']['cognito_token']
      r = Aws::STS::Client.new.assume_role_with_web_identity(role_arn: Config.aws_role_arn,
                                                             web_identity_token: cognito_token,
                                                             role_session_name: Config.aws_api_gw_service_name)

      credential = Aws::Credentials.new(r.credentials.access_key_id,
                                        r.credentials.secret_access_key,
                                        r.credentials.session_token)

      Aws.config[:credentials] = credential

      credential
    end
  end
end