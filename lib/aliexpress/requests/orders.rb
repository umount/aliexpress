module Aliexpress
  module Requests
    class Orders
      include Aliexpress::Requests::InstanceModule

      def complited(params)
        api_endpoint 'getCompletedOrders'

        response(params)
      end

      def get_by_number(params)
        api_endpoint 'getItemByOrderNumbers'

        response(params)
      end
    end
  end
end
