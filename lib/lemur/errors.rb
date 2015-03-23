module Lemur
  class ApiError < StandardError
    attr_reader :data

    def error_code
      @data['error_code']
    end

    def error_data
      @data['error_data']
    end

    def error_msg
      @data['error_msg']
    end

    def initialize(data)
      @data = data
      message = "#{error_code}: #{error_msg}"
      super(message)
    end
  end

  class ApiParsingError < StandardError
    attr_reader :url
    attr_reader :body

    def initialize(responce)
      @url = responce.env[:url].to_s
      @body = responce.body
      message = "Wrong JSON at #{url}: #{body}"
      super(message)
    end
  end
end
