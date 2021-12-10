# frozen_string_literal: true

require 'phone_validation/version'
require 'phone_validation/validation_request'
require 'json'
require 'phone_validation/errors'

module PhoneValidation
  class Client
    attr_accessor :phone_number, :token

    def initialize(token:, phone_number:)
      @token = token
      @phone_number = phone_number
    end

    def valid?
      request_validation['valid'] == true
    end

    PhoneValidation::ValidationRequest::RESPONSE_FIELDS.each do |field|
      define_method :"#{field}" do
        request_validation[field].to_s
      end
    end

    private

    def request_validation
      valid_response? ? validation_response : raise_response_error
    end

    def validation_response
      @validation_response ||= JSON.parse(
        ValidationRequest.new(
          token: token,
          phone_number: phone_number
        ).call
      )
    end

    def valid_response?
      !validation_response.key?('error')
    end

    def raise_response_error
      raise Errors::ApiInternalError, validation_response.dig('error', 'info')
    end
  end
end
