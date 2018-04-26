module Chikyu::Sdk
  # Http送信に関するエラー
  class HttpError < StandardError
  end

  # APIの実行エラー
  class ApiExecuteError < StandardError
  end
end