module Aliexpress
  module Response
    module ClassMethods
      def parse_request(&request)
        begin
          response = request.call
        rescue => error
          Aliexpress::Errors::Internal.new(error)
        end

        if response.code == 200
          fetch_data(response)
        else
          raise Aliexpress::Errors::ExternalServiceUnavailable.new(
            "#{response.code} / #{response.body}"
          )
        end
      end

      def fetch_data(response)
        _response = JSON.parse(response.body)
        error_code = _response['errorCode'].to_i

        if error_code == 20010000
          _response['result']
        else
          error_message = "#{error_code} / #{get_error(error_code)}"

          case error_code
          when 20030000
            raise Aliexpress::Errors::UnauthorizedAccess.new(error_message)
          else
            raise Aliexpress::Errors::BadRequest.new(error_message)
          end
        end
      end

      def get_error(code)
        Aliexpress::Errors::CodeDescription.get(code)
      end
    end

    extend ClassMethods
  end
end
