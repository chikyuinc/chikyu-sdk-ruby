require 'yaml'


module ChikyuSdk
  # テストの設定をロードする
  class TestConfig
    def self.load
      YAML.load_file "../config.#{ChikyuSdk::Config.mode}.yml"
    end
  end

end
