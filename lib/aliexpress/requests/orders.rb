module Aliexpress
  module Requests
    class Orders
      include Aliexpress::Requests::InstanceModule

      def complited(params)
        api_endpoint 'aliexpress.affiliate.order.list'
        params = {status: 'Payment Completed'}.merge(params)

        response(params)
      end

      def confirmed(params)
        api_endpoint 'aliexpress.affiliate.order.list'
        params = {status: 'Buyer Confirmed Receipt'}.merge(params)

        response(params)
      end

      def complited_by_index(params)
        api_endpoint 'aliexpress.affiliate.order.listbyindex'
        params = {status: 'Payment Completed'}.merge(params)
      end

      def confirmed_by_index(params)
        api_endpoint 'aliexpress.affiliate.order.listbyindex'
        params = {status: 'Buyer Confirmed Receipt'}.merge(params)
      end

      def get_status(params)
        api_endpoint 'aliexpress.affiliate.order.get'

        response(params)
      end
    end
  end
end
