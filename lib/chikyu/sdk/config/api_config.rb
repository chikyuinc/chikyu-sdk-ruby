module Chikyu::Sdk
  # 環境設定関連
  class ApiConfig
    @@mode = 'prod'

    HOSTS = {
      local: 'localhost:9090',
      docker: 'dev-python:9090',
      devdc: 'gateway.chikyu.mobi',
      dev01: 'gateway.chikyu.mobi',
      dev02: 'gateway.chikyu.mobi',
      hotfix01: 'gateway.chikyu.mobi',
      prod: 'endpoint.chikyu.net'
    }.freeze

    PROTOCOLS = {
      local: 'http',
      docker: 'http',
      devdc: 'https',
      dev01: 'https',
      dev02: 'https',
      hotfix01: 'https',
      prod: 'https'
    }.freeze

    ENV_NAMES = {
      local: '',
      docker: '',
      devdc: 'dev',
      dev01: 'dev01',
      dev02: 'dev02',
      hotfix01: 'hotfix01',
      prod: ''
    }.freeze

    def self.aws_region
      'ap-northeast-1'.freeze
    end

    def self.aws_role_arn
      if @@mode == 'prod'
        'arn:aws:iam::171608821407:role/Cognito_chikyu_PROD_idpoolAuth_Role'.freeze
      elsif @@mode == 'docker' || @@mode == 'local'
        'arn:aws:iam::527083274078:role/Cognito_ChikyuDevLocalAuth_Role'.freeze
      else
        'arn:aws:iam::171608821407:role/Cognito_Chikyu_Normal_Id_PoolAuth_Role'.freeze
      end
    end

    def self.aws_api_gw_service_name
      'execute-api'.freeze
    end

    def self.protocol
      PROTOCOLS[mode.to_sym]
    end

    def self.host
      HOSTS[mode.to_sym]
    end

    def self.env_name
      ENV_NAMES[mode.to_sym]
    end

    def self.mode
      @@mode
    end

    def self.mode=mode
      @@mode = mode
    end

    def self.with_debug
      false
    end
  end
end
