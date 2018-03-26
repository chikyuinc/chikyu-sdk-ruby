module Chikyu::Sdk
  # APIキーの作成・削除を行う
  class ApiAuthKey
    def initialize(session)
      @session = session
    end

    def create(api_key_name, role_id=nil, allowed_hosts=nil)
      SecureResource.new(@session).invoke(path: '/system/api_auth_key/create',
                                          data: { api_key_name: api_key_name,
                                                  role_id: role_id,
                                                  allowed_hosts: allowed_hosts })
    end

    def revoke(auth_key_id)
      SecureResource.new(@session).invoke(path: '/system/api_auth_key/revoke',
                                          data: { _id: auth_key_id })
    end

    def list
      SecureResource.new(@session).invoke(path: '/system/api_auth_key/list', data: {})
    end
  end

end