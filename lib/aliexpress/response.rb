module Aliexpress
  module Response
    module ClassMethods
      def parse_request(request_method)
        begin
          response = yield
        rescue => error
          Aliexpress::Errors::Internal.new(error)
        end

        if response.is_a?(RestClient::Response)
          if response.code == 200
            fetch_data(request_method, response)
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

      def fetch_data(request_method, response)
        _response = JSON.parse(response.body)

        if _response.key?('error_response')
          error = _response['error_response']
          error_message = "#{error['code']} / #{error['msg']}"

          raise Aliexpress::Errors::BadRequest.new(error_message)
        else
          response_name = request_method.gsub('.', '_') + '_response'
          _response[response_name]['resp_result']
        end
      end
    end

    extend ClassMethods
  end
end
