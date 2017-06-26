module Aliexpress
  module Requests
    module Utils
      def request(config, params)
        params.merge!({appSignature: config[:api_signature]}) if api_signature?

        RestClient.get(api_endpoint(config), { params: params })
      end

      def api_endpoint(config, signature=false)
        module_name = self.name.split('::').last
        request_path = module_name[0, 1].downcase + module_name[1..-1]
        endpoint = [config[:api_url], request_path, '/', config[:api_key]].join('')
      end

      def api_signature(required=false)
        @api_signature = required
      end

      def api_signature?
        @api_signature
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
        class_path = method_name.to_s.split(/\_/).map(&:capitalize).join('')
        class_name = "Aliexpress::Requests::#{class_path}"

        if Object.const_defined?(class_name)
          _instanse = Object.const_get(class_name)
          _instanse.request(@config, *args)
        else
          super
        end
      end

    end
  end
end
