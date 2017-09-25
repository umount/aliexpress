module Aliexpress
  module Response
    module ClassMethods
      def parse_request(api_endpoint)
        begin
          response = yield
        rescue => error
          Aliexpress::Errors::Internal.new(error)
        end

        if response.code == 200
          fetch_data(api_endpoint, response)
        else
          raise Aliexpress::Errors::ExternalServiceUnavailable.new(
            "#{response.code} / #{response.body}"
          )
        end
      end

      def fetch_data(api_endpoint, response)
        _response = JSON.parse(response.body)
        error_code = _response['errorCode'].to_i

        if error_code == 20010000
          _response['result']
        else
          error_message = "#{error_code} / #{get_error(api_endpoint, error_code)}"

          raise Aliexpress::Errors::BadRequest.new(error_message)
        end
      end

      def get_error(api_endpoint, code)
        Aliexpress::Errors::CodeDescription.get(api_endpoint, code)
      end
    end

    extend ClassMethods
  end
end
