module Aliexpress
  module Requests
    class Orders
      include Aliexpress::Requests::InstanceModule

      def complited(params)
        api_endpoint 'getCompletedOrders'

        response(params)
      end

      def get_status(params)
        api_endpoint 'getOrderStatus'

        response(params)
      end
    end
  end
end
