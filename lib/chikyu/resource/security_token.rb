module Chikyu
  # 認証トークンの生成/破棄を行う
  class SecurityToken
    def self.create(token_name, email, password, duration=nil)
      item = OpenResource.invoke(path: '/session/token/create',
                                 data: {token_name: token_name,
                                        email: email,
                                        password: password,
                                        duration: duration})
      item['data']
    end

    def self.renew(token_name, login_token, login_secret_token)
      OpenResource.invoke(path: '/session/token/renew',
                          data: {token_name: token_name,
                                 login_token: login_token,
                                 login_secret_token: login_secret_token})
      item['data']
    end

    def self.revoke(token_name, login_token, login_secret_token)
      OpenResource.invoke(path: '/session/token/revoke',
                          data: {token_name: token_name,
                                 login_token: login_token,
                                 login_secret_token: login_secret_token})
      item['data']
    end
  end
end
