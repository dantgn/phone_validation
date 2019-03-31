# frozen_string_literal: true

require 'phone_validation/version'
require 'phone_validation/validation_request'
require 'json'

module PhoneValidation
  class InvalidToken < StandardError; end
  class InvalidNumber < StandardError; end
  class ApiInternalError < StandardError; end

  class Client
    RESPONSE_FIELDS = %w[
      local_format
      international_format
      country_prefix
      country_code
      country_name
      location
      carrier
      line_type
    ].freeze

    def initialize(token, number)
      raise InvalidToken, "Token can't be nil" if token.nil?
      raise InvalidNumber, "Phone number can't be nil" if number.nil?

      @token = token
      @number = number
    end

    def valid?
      request_validation['valid'] == true
    end

    RESPONSE_FIELDS.each do |field|
      define_method :"#{field}" do
        request_validation[field].to_s
      end
    end

    private

    def request_validation
      return validation_response if valid_response?

      raise_response_error
    end

    def validation_response
      @validation_response ||= JSON.parse(ValidationRequest.new(@token, @number).call)
    end

    def valid_response?
      !validation_response.key?('error')
    end

    def raise_response_error
      raise ApiInternalError, validation_response.dig('error', 'info')
    end
  end
end
