require 'rest-client'
require 'json'

require 'aliexpress/version'
require 'aliexpress/errors'
require 'aliexpress/response'
require 'aliexpress/requests'

Dir[
    File.expand_path('../aliexpress/requests/*.rb', __FILE__)
].each { |f|
  require f
}

module Aliexpress
  module ClassMethods
    def new(config)
      configure(config)

      Aliexpress::Requests::Class.new(@config)
    end

    def configure(config={})
      @config = {
        api_url: 'https://gw.api.alibaba.com/openapi/param2/2/portals.open/api.',
        api_key: false,
        api_secret: false
      }.merge!(config)
    end
  end

  extend ClassMethods
end
