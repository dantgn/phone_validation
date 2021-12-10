# frozen_string_literal: true
require 'uri'
require 'net/http'

module PhoneValidation
  class ValidationRequest
    attr_accessor :phone_number, :token

    BASE_URL = 'http://apilayer.net/api/validate'
    RESPONSE_FIELDS = %w[
      carrier
      country_code
      country_name
      country_prefix
      international_format
      line_type
      location
      local_format
    ].freeze

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
      @url ||= URI("#{BASE_URL}?#{url_params}")
    end

    def url_params
      params_hash.map { |key, value| "#{key}=#{value}" }.join('&')
    end

    def params_hash
      {
        access_key: token,
        number: phone_number
      }
    end

    def new_request
      request = Net::HTTP::Get.new(url)
      request['Content-Type'] = 'application/json'
      request
    end

    def http
      Net::HTTP.new(url.host, url.port)
    end
  end
end
