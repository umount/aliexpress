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
    expect(aliexpress.configure).to include(:api_key, :api_signature, :api_url)

    expect(aliexpress.configure[:api_key]).to eq(Settings.aliexpress.api_key)
    expect(aliexpress.configure[:api_signature]).to eq(
      Settings.aliexpress.api_signature
    )
  end

  describe 'API getCompletedOrders' do
    it 'bad request 20030000 required parameter' do
      expect {
        result = aliexpress.orders.complited(
          startDate: '2017-07-01',
          endDate: '2017-09-27'
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
        startDate: '2017-07-01',
        endDate: '2017-09-27',
        liveOrderStatus: 'pay'
      )

      expect(result['orders'].count).to eq(0)
    end
  end

  it 'getItemByOrderNumbers' do
    requests = aliexpress.orders.get_by_number(
      orderNumbers: '84842060660980'
    )

    puts "=========#{requests}="
  end

  it 'autoload requests class' do
    requests = aliexpress.list_promotion_creative(
      category: 'all', language: 'en'
    )
  end


  it 'getOrderStatus' do
    requests = aliexpress.get_order_status(
      orderNumbers: '84842060660980'
    )
  end

end
