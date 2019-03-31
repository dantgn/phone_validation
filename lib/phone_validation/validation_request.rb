# frozen_string_literal: true

module PhoneValidation
  class ValidationRequest
    require 'uri'
    require 'net/http'

    def initialize(token, phone_number)
      @phone_number = phone_number
      @token = token
    end

    def call
      response = http.request(new_request)

      response.read_body
    end

    private

    def url
      @url ||= URI("http://apilayer.net/api/validate?#{url_params}")
    end

    def url_params
      "access_key=#{@token}&number=#{@phone_number}"
    end

    def new_request
      request = Net::HTTP::Get.new(url)
      request['x-api-token'] = @token
      request['Content-Type'] = 'application/json'
      request
    end

    def http
      Net::HTTP.new(url.host, url.port)
    end
  end
end
