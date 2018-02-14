require 'chikyu/sdk/version'

require 'aws-sdk'
require 'faraday'
require 'json'
require 'logger'

require 'faraday_middleware'
require 'faraday_middleware/aws_signers_v4'

require 'chikyu/sdk/errors/common_errors'

require 'chikyu/sdk/config/config'
require 'chikyu/sdk/api_resource'
require 'chikyu/sdk/open_api_resource'
require 'chikyu/sdk/public_api_resource'
require 'chikyu/sdk/secure_api_resource'

require 'chikyu/sdk/resource/security_token'
require 'chikyu/sdk/resource/session'
require 'chikyu/sdk/resource/api_key'


module Chikyu
  module Sdk

  end
end

Aws.config[:region] = Chikyu::Sdk::Config.aws_region
if Chikyu::Sdk::Config.with_debug
  Aws.config[:logger] = Logger.new($stdout)
  Aws.config[:log_level] = :debug
end
