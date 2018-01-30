module Chikyu
  # セキュリティトークンを元にログイン / ログアウトを行う
  class Session
    attr_reader :chikyu_session_id
    attr_reader :aws_api_key
    attr_reader :aws_credential

    def login(resource)
      token_name = resource[:token_name] ? resource[:token_name] : resource['token_name']
      login_token = resource[:login_token] ? resource[:login_token] : resource['login_token']
      login_secret_token =
        resource[:login_secret_token] ? resource[:login_secret_token] : resource['login_secret_token']

      tokens = __login(token_name, login_token, login_secret_token)
      credential = __create_aws_token(tokens)

      @chikyu_session_id = tokens['data']['session_id']
      @aws_api_key = tokens['data']['api_key']
      @aws_credential = credential

      self
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
      r = Aws::STS::Client.new.assume_role_with_web_identity(role_arn: AWS_ROLE_ARN,
                                                             web_identity_token: cognito_token,
                                                             role_session_name: 'execute-api')

      credential = Aws::Credentials.new(r.credentials.access_key_id,
                                        r.credentials.secret_access_key,
                                        r.credentials.session_token)

      Aws.config[:credentials] = credential

      credential
    end
  end
end