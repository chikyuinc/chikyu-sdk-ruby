module ChikyuSdk
  # 環境設定関連
  class Config
    def self.aws_region
      'ap-northeast-1'.freeze
    end

    def self.aws_role_arn
      'arn:aws:iam::171608821407:role/Cognito_Chikyu_Normal_Id_PoolAuth_Role'.freeze
    end

    def self.aws_api_gw_service_name
      'execute-api'
    end

    def self.protocol
      if mode == 'local'
        'http'.freeze
      elsif mode == 'dev'
        'https'.freeze
      end
    end

    def self.host
      if mode == 'local'
        'localhost:9090'.freeze
      elsif mode == 'dev'
        'gateway.chikyu.mobi'.freeze
      end
    end

    def self.env_name
      if mode == 'local'
        'local'.freeze
      elsif mode == 'dev'
        'dev'.freeze
      end
    end

    def self.mode
      'dev'.freeze
    end

    def self.with_debug
      false
    end
  end
end
