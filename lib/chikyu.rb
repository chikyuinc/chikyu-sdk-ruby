require 'aws-sdk'
require 'faraday'
require 'json'
require 'logger'

require 'faraday_middleware'
require 'faraday_middleware/aws_signers_v4'

require_relative 'chikyu/errors/common_errors'

require_relative 'chikyu/const'
require_relative 'chikyu/open_api_resource'
require_relative 'chikyu/secure_api_resource'

require_relative 'chikyu/resource/security_token'
require_relative 'chikyu/resource/session'

# モジュール定義
module Chikyu

end

Aws.config[:region] = Chikyu::AWS_REGION
if Chikyu::WITH_DEBUG
  Aws.config[:logger] = Logger.new($stdout)
  Aws.config[:log_level] = :debug
end
