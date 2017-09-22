module Aliexpress
  module Requests
    module InstanceModule
      mattr_accessor :config, :request_url, :endpoint
      mattr_accessor :api_signature do true end

      def request(params)
        params.merge!({appSignature: config[:api_secret]}) if api_signature

        RestClient.get(request_url, { params: params })
      end

      def response(params)
        Aliexpress::Response.parse_request endpoint do
          request(params)
        end
      end

      def api_endpoint(request_path)
        self.request_url = [config[:api_url], request_path, '/', config[:api_key]].join('')
        self.endpoint = request_path

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
