# encoding: UTF-8
require 'tower_data'

module TowerData
  class TestProvider < TowerData::Provider
    def initialize(token)
      @token = token
    end

    def validate_email(address)
      username, domain = address.split('@')
      response = {
        'email' => {
          'address'  => address,
          'domain'   => domain,
          'username' => username,
          'ok'       => (domain == 'example.com') ? false : true
        }
      }
      TowerData::Email.new(response)
    end
  end
end
