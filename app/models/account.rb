require 'klaviyo_api'

class Account
  attr_accessor :api_key

  def initialize(api_key)
    @api_key = api_key
  end

  def with_klaviyo_session(&block)
    KlaviyoAPI::Session.temp api_key, &block
  end
end