module Aliexpress
  module Requests
    module InstanceModule
      mattr_accessor :config, :method_params, :request_method
      mattr_accessor :api_signature do true end

      def request(params)
        params.merge!(method_params)
        params = params.sort.to_h

        sign_string = params.map{|h| h.to_a}.flatten(1).join('')
        signature = OpenSSL::HMAC.hexdigest("MD5", config[:api_secret], sign_string)

        params.merge!({sign: signature.upcase})

        begin
          RestClient.post(config[:api_url], params)
        rescue RestClient::ExceptionWithResponse => e
          e.response
        end
      end

      def response(params)
        Aliexpress::Response.parse_request request_method do
          request(params)
        end
      end

      def api_endpoint(request_method)
        params = {
          format: 'json', v: '2.0', sign_method: 'hmac', app_key: config[:api_key],
          timestamp: Time.now.strftime('%Y-%m-%d %H:%M:%S')
        }

        self.request_method = request_method
        self.method_params = params.merge!(method: request_method)

        self
      end
    end

    class Class
      def initialize(params={})
        configure(params)
      end

      def configure(config=false)
        @config = config || @config
      end

      def method_missing(method_name, *args, &block)
        class_path = method_name.capitalize
        class_name = "Aliexpress::Requests::#{class_path}"

        if Object.const_defined?(class_name)
          _instanse = Object.const_get(class_name).new
          _instanse.config = @config
          _instanse
        else
          super
        end
      end
    end
  end
end
