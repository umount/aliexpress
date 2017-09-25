module Aliexpress
  module Requests
    class Products
      include Aliexpress::Requests::InstanceModule

      def list_promotion(params)
        api_endpoint 'listPromotionProduct'

        self.api_signature = false

        response(params)
      end

      def get_by_number(params)
        api_endpoint 'getItemByOrderNumbers'

        response(params)
      end
    end
  end
end
