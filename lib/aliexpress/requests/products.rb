module Aliexpress
  module Requests
    class Products
      include Aliexpress::Requests::InstanceModule

      def list_promotion(params)
        api_endpoint 'aliexpress.affiliate.product.query'

        response(params)
      end

    end
  end
end
