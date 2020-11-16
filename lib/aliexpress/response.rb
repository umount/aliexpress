module Aliexpress
  module Response
    module ClassMethods
      def parse_request(api_endpoint)
        begin
          response = yield
        rescue => error
          Aliexpress::Errors::Internal.new(error)
        end

        pp response.body
        if response.is_a?(RestClient::Response)
          if response.code == 200
            fetch_data(api_endpoint, response)
          else
            raise Aliexpress::Errors::ExternalServiceUnavailable.new(
              "#{response.code} / #{response.body}"
            )
          end
        else
          raise Aliexpress::Errors::ExternalServiceUnavailable.new(
            "WTF? #{response.inspect}"
          )
        end
      end

      def fetch_data(api_endpoint, response)
        _response = JSON.parse(response.body)

        if _response.key?('error_response')
          error = _response['error_response']
          error_message = "#{error['code']} / #{error['msg']}"

          raise Aliexpress::Errors::BadRequest.new(error_message)
        else
          _response['result']
        end
      end

      def get_error(api_endpoint, code)
        Aliexpress::Errors::CodeDescription.get(api_endpoint, code)
      end
    end

    extend ClassMethods
  end
end
