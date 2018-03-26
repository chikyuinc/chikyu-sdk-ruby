require 'yaml'


module Chikyu::Sdk
  # テストの設定をロードする
  class TestConfig
    def self.load(mode)
      Chikyu::Sdk::ApiConfig.mode = mode
      YAML.load_file "../config.#{Chikyu::Sdk::ApiConfig.mode}.yml"
    end
  end

end
