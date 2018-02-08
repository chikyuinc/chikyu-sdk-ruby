require 'yaml'


module Chikyu
  # テストの設定をロードする
  class TestConfig
    def self.load
      YAML.load_file "../config.#{Chikyu::Config.mode}.yml"
    end
  end

end
