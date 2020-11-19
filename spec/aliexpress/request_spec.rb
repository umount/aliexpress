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

      it 'bad request 40 required parameter' do
        expect {
          result = aliexpress.orders.complited(
            start_time: (Time.now - (3600 * 48)).strftime('%Y-%m-%d %H:%M:%S'),
          )
        }.to raise_error(Aliexpress::Errors::BadRequest, /40 \/ Missing required arguments:end_time/)
      end

      it 'get success: completed order' do
        result = aliexpress.orders.complited(
          start_time: (Time.now - (3600 * 24)).strftime('%Y-%m-%d %H:%M:%S'),
          end_time: (Time.now + (3600 * 24)).strftime('%Y-%m-%d %H:%M:%S'),
        )

        expect(result['resp_code']).to eq(200)
        expect(result['result']['current_record_count']).to be > 0
      end

      it 'get success：confirmed success' do
        result = aliexpress.orders.confirmed(
          start_time: (Time.now - (3600 * 48)).strftime('%Y-%m-%d %H:%M:%S'),
          end_time: (Time.now - (3600 * 24)).strftime('%Y-%m-%d %H:%M:%S')
        )

        expect(result['resp_code']).to eq(200)
        expect(result['result']['current_record_count']).to be > 0
      end
    end


    describe 'API getOrderStatus' do
      it 'bad request required parameter' do
         result = aliexpress.orders.get_status({})
         expect(result['resp_code']).to eq(406)
         expect(result['resp_msg']).to eq('The value of input params  is empty :null')
      end

      it 'empty result' do
        result = aliexpress.orders.get_status(
          order_ids: '84842060660980'
        )

        expect(result['resp_code']).to eq(405)
        expect(result['resp_msg']).to eq('The result is empty')
      end

      it 'success one request' do
        result = aliexpress.orders.get_status(
          order_ids: '8121534304466797'
        )

        expect(result['resp_code']).to eq(200)
        expect(result['result']['current_record_count']).to eq(1)
      end

      it 'success several request' do
        result = aliexpress.orders.get_status(
          order_ids: '8121404327155217,8121410984130215'
        )

        expect(result['resp_code']).to eq(200)
        expect(result['result']['current_record_count']).to eq(2)
      end
    end
  end

  describe 'Products API requests' do
    describe 'API listPromotionProduct' do
      it 'success keywords request' do
        result = aliexpress.products.list_promotion(
          keywords: 'phone'
        )
        expect(result['resp_code']).to eq(200)
        expect(result['result']['current_record_count']).to eq(50)
      end
    end
  end
end
