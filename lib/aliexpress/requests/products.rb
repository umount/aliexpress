module Aliexpress
  module Requests
    module Products
      include Aliexpress::Requests::InstanceModule

      def list_similar(params)
        api_endpoint 'listSimilarProducts'

        request(params)
      end
    end
  end
end
