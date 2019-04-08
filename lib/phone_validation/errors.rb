# frozen_string_literal: true

module PhoneValidation
  module Errors
    class InvalidToken < StandardError; end
    class InvalidNumber < StandardError; end
    class ApiInternalError < StandardError; end
  end
end
