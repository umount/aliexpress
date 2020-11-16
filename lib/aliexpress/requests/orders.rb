module Aliexpress
  module Requests
    class Orders
      include Aliexpress::Requests::InstanceModule

      def complited(params)
        api_endpoint 'aliexpress.affiliate.order.list'

        response(params)
      end

      def get_status(params)
        api_endpoint 'aliexpress.affiliate.order.get'

        response(params)
      end
    end
  end
end
