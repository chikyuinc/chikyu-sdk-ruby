module ChikyuSdk
  # Http送信に関するエラー
  class HttpError < StandardError
    attr_reader :message
    attr_reader :status
    attr_reader :body

    def initialize(message, status, body)
      @message = message
      @status = status
      @body = body

    end

    def to_s
      "#{@message} / http_status:#{@status}. http_body:#{@body}"
    end
  end

  # APIの実行エラー
  class ApiExecuteError < StandardError
    attr_reader :api_path
    attr_reader :params
    attr_reader :message

    def initialize(api_path, params, message)
      @api_path = api_path
      @params = params
      @message = message

      p 'error_api_path: ' + api_path
      p 'error_api_param:' + params.to_s
    end

    def to_s
      "#{@message} / api_path: #{@api_path}. params: #{@params}"
    end
  end
end