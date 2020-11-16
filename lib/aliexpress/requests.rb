module Aliexpress
  module Requests
    module InstanceModule
      mattr_accessor :config, :method_params, :endpoint
      mattr_accessor :api_signature do true end

      def request(params)
        params.merge!(method_params)

        sign_string = params.map{|h| h.to_a}.flatten(1).join('')
        signature = Digest::MD5.hexdigest(
          config[:api_secret] + sign_string + config[:api_secret]
        )
        params.merge!({sign: signature})

        begin
          RestClient.post(config[:api_url], params)
        rescue RestClient::ExceptionWithResponse => e
          e.response
        end
      end

      def response(params)
        Aliexpress::Response.parse_request endpoint do
          request(params)
        end
      end

      def api_endpoint(request_method)
        params = {format: 'json', v: '2.0', sign_method: 'hmac', app_key: config[:api_key]}

        self.endpoint = config[:api_url]
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
