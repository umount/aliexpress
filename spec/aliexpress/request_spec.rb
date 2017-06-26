require 'spec_helper'

describe Aliexpress do
  let(:aliexpress) {
    Aliexpress.new(
      api_key: Settings.aliexpress.api_key,
      api_signature: Settings.aliexpress.api_signature,
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

  it 'autoload requests class' do
    requests = aliexpress.list_promotion_creative(
      category: 'all', language: 'en'
    )
  end

  it 'getItemByOrderNumbers' do
    requests = aliexpress.get_item_by_order_numbers(
      orderNumbers: '84842060660980'
    )
  end

  it 'getOrderStatus' do
    requests = aliexpress.get_order_status(
      orderNumbers: '84842060660980'
    )
  end

  it 'getCompletedOrders' do
    requests = aliexpress.get_completed_orders(
      startDate: '2017-01-01',
      endDate: '2017-07-27',
      liveOrderStatus: 'pay'
    )
  end
end
