require 'spec_helper'

describe Aliexpress do
  let(:aliexpress) {
    Aliexpress.new(
      api_key: Settings.aliexpress.api_key,
      api_secret: Settings.aliexpress.api_secret,
      tracking_link: 'http://s.click.aliexpress.com/e/NvFqR3f'
    )
  }

  it 'initial configuration' do
    expect(aliexpress.configure).to include(:api_key, :api_secret, :api_url)

    expect(aliexpress.configure[:api_key]).to eq(Settings.aliexpress.api_key)
    expect(aliexpress.configure[:api_secret]).to eq(
      Settings.aliexpress.api_secret
    )
  end

  describe 'Orders API requests' do
    describe 'API getCompletedOrders' do
      it 'invalid bad API key' do
        aliexpress.configure[:api_key] = '-'

        expect {
          result = aliexpress.orders.complited(
            start_time: '2017-07-01'
          )
        }.to raise_error(Aliexpress::Errors::BadRequest, /29 \/ Invalid app Key/)
      end

      it 'bad request 20030000 required parameter' do
        expect {
          result = aliexpress.orders.complited(
            star_time: '2017-07-01',
            end_time: '2017-09-27'
          )
        }.to raise_error(Aliexpress::Errors::BadRequest, /20030000/)
      end

      it 'get success: completed order' do
        result = aliexpress.orders.complited(
          startDate: '2017-07-01',
          endDate: '2017-09-27',
          liveOrderStatus: 'success'
        )

        expect(result['orders'].count).to be > 0
      end

      it 'get pay：payment success' do
        result = aliexpress.orders.complited(
          startDate: '2019-08-05',
          endDate: '2019-08-06',
          liveOrderStatus: 'pay'
        )

        puts result
        expect(result['orders'].count).to eq(0)
      end
    end


    describe 'API getOrderStatus' do
      it 'bad request 20030000 required parameter' do
        expect {
          result = aliexpress.orders.get_status({})
        }.to raise_error(Aliexpress::Errors::BadRequest, /20030000/)
      end

      it 'success one request' do
        result = aliexpress.orders.get_status(
          orderNumbers: '8000045804775842'
        )

        puts result
        expect(result['orders'].count).to eq(1)
      end

      it 'success several request' do
        result = aliexpress.orders.get_status(
          orderNumbers: '84842060660980,84842060660981'
        )

        puts result
        expect(result['orders'].count).to eq(2)
      end
    end
  end

  describe 'Products API requests' do
    describe 'API getItemByOrderNumbers' do
      it 'one order params' do
        result = aliexpress.products.get_by_number(
          orderNumbers: '8000045804775842'
        )

        puts result
        expect(result['products'].count).to eq(1)
      end

      it 'bad request 20030000 required parameter' do
        expect {
          result = aliexpress.products.get_by_number({})
        }.to raise_error(Aliexpress::Errors::BadRequest, /20030000/)
      end
    end

    describe 'API listPromotionProduct' do
      it 'discount input parameter error' do
        expect {
          result = aliexpress.products.list_promotion(
            category: 'all', language: 'en'
          )
        }.to raise_error(Aliexpress::Errors::BadRequest, /20030120/)
      end

      it 'success keywords request' do
        result = aliexpress.products.list_promotion(
          fields: 'productUrl,productTitle',
          keywords: 'phone'
        )

        expect(result['products'].count).to eq(20)
      end
    end
  end
end
