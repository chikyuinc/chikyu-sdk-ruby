require 'yaml'


module Chikyu::Sdk
  # テストの設定をロードする
  class TestConfig
    def self.load
      YAML.load_file "../config.#{Chikyu::Sdk::Config.mode}.yml"
    end
  end

end
