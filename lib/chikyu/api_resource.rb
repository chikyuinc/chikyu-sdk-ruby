module Chikyu
  # API抽象クラス
  class ApiResource
    def self.handle_response(res)
      if res.success?
        body = res.body
        data = body.instance_of?(String) ? JSON.parse(body) : body

        raise ApiExecuteError.new(path, params, data['message']) if data['has_error']

        return data
      end

      raise HttpError.new('リクエストの送信に失敗しました', res.status, res.body)
    end
  end

end