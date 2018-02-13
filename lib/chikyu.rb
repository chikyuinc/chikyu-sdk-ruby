require "chikyu/version"

require 'aws-sdk'
require 'faraday'
require 'json'
require 'logger'

require 'faraday_middleware'
require 'faraday_middleware/aws_signers_v4'

require 'chikyu/errors/common_errors'

require 'chikyu/config/config'
require 'chikyu/api_resource'
require 'chikyu/open_api_resource'
require 'chikyu/public_api_resource'
require 'chikyu/secure_api_resource'

require 'chikyu/resource/security_token'
require 'chikyu/resource/session'
require 'chikyu/resource/api_key'


module Chikyu

end

Aws.config[:region] = Chikyu::Config.aws_region
if Chikyu::Config.with_debug
  Aws.config[:logger] = Logger.new($stdout)
  Aws.config[:log_level] = :debug
end
