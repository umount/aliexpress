require 'spec_helper'

describe Aliexpress do
  let(:aliexpress) {
    Aliexpress.new(
      api_key: Settings.aliexpress.api_key,
      api_signature: Settings.aliexpress.api_signature
    )
  }

  it 'initial configuration' do
    expect(aliexpress.configure).to include(:api_key, :api_signature, :api_url)

    expect(aliexpress.configure[:api_key]).to eq(Settings.aliexpress.api_key)
    expect(aliexpress.configure[:api_signature]).to eq(Settings.aliexpress.api_signature)
  end

  it 'autoload requests class' do
    requests = aliexpress.list_promotion_creative(
      category: 'all', language: 'en'
    )
  end
end
