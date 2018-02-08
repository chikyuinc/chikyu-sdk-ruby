require 'aws-sdk'
require 'faraday'
require 'json'
require 'logger'

require 'faraday_middleware'
require 'faraday_middleware/aws_signers_v4'

require_relative 'chikyu/errors/common_errors'

require_relative 'chikyu/config/config'
require_relative 'chikyu/api_resource'
require_relative 'chikyu/open_api_resource'
require_relative 'chikyu/public_api_resource'
require_relative 'chikyu/secure_api_resource'

require_relative 'chikyu/resource/security_token'
require_relative 'chikyu/resource/session'
require_relative 'chikyu/resource/api_key'

# モジュール定義
module Chikyu

end

Aws.config[:region] = Chikyu::Config.aws_region
if Chikyu::Config.with_debug
  Aws.config[:logger] = Logger.new($stdout)
  Aws.config[:log_level] = :debug
end
