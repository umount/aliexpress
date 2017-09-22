module Aliexpress
  module Errors
    class CustomError < StandardError
      cattr_accessor :code
      attr_reader :description

      def initialize(description = nil)
        super(description)
        @description = description
      end

      self.code = 399
    end

    class BadRequest < CustomError;                 self.code = 400 end
    class UnauthorizedAccess < CustomError;         self.code = 401 end
    class Forbidden < CustomError;                  self.code = 403 end
    class NotFound < CustomError;                   self.code = 404 end
    class TooManyRequests < CustomError;            self.code = 429 end
    class Internal < CustomError;                   self.code = 500 end
    class ExternalServiceUnavailable < CustomError; self.code = 503 end

    module CodeDescription
      def get(endpoint, code)
        @listPromotionProduct = {
          20010000 => 'Call succeeds',
          20020000 => 'System Error',
          20030000 => 'Unauthorized transfer request',
          20030010 => 'Required parameters',
          20030020 => 'Invalid protocol format',
          20030030 => 'API version input parameter error',
          20030040 => 'API name space input parameter error',
          20030050 => 'API name input parameter error',
          20030060 => 'Fields input parameter error',
          20030070 => 'Keyword input parameter error',
          20030080 => 'Category ID input parameter error',
          20030090 => 'Tracking ID input parameter error',
          20030100 => 'Commission rate input parameter error',
          20030110 => 'Original Price input parameter error',
          20030120 => 'Discount input parameter error',
          20030130 => 'Volume input parameter error',
          20030140 => 'Page number input parameter error',
          20030150 => 'Page size input parameter error',
          20030160 => 'Sort input parameter error',
          20030170 => 'Credit Score input parameter error'
        }

        @getCompletedOrders = {
          20010000 => 'Call succeeds',
          20020000 => 'System Error',
          20030000 => 'Required Parameter error',
          20030070 => 'Unauthorized transfer request',
          20030140 => 'Page number input parameter error',
          20030150 => 'Page size input parameter error'
        }

        error_list = instance_variable_get("@#{endpoint}")
        error_list ? error_list[code] : code
      end

      extend self
    end
  end
end
