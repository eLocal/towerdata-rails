# encoding: UTF-8
require 'tower_data'
require 'httparty'

module TowerData
  class NotSupportedByProviderError < StandardError; end

  class Provider
    def validate_email(address)
      raise NotSupportedByProviderError, 'TowerData::Provider#validate_email'
    end

    def validate_phone(number)
      raise NotSupportedByProviderError, 'TowerData::Provider#validate_phone'
    end
  end

  class TowerDataDefault < TowerData::Provider
    include HTTParty
    base_uri 'http://api10.towerdata.com'

    def initialize
    end

    def validate_email(address)
      opts = {
        headers: TowerData.config.headers,
        query: {
          license: TowerData.config.token,
          correct: 'email',
          email: address
        }
      }

      with_valid_response('/person', opts) do |response|
        TowerData::Email.new(response)
      end
    end

    def validate_phone(number)
      opts = {
        headers: TowerData.config.headers,
        query: {
          license: TowerData.config.token,
          phone: number
        }
      }

      with_valid_response('/person', opts) do |response|
        TowerData::Phone.new(response)
      end
    end

    def with_valid_response(url, opts, &block)
      response = self.class.get(url, opts)
      case response.code
      when 200
        # All good
      when 401, 403
        raise TokenInvalidError
      when 500
        raise UnknownServerError.new("Problem with request.  Response '#{response}'")
      else
        raise BadConnectionToAPIError.new("Unknown status error #{response.code}: #{response}")
      end
      yield response
    end
  end
end
