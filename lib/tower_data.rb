require 'httparty'
require 'json'

module TowerData
  include HTTParty
  base_uri 'http://api10.towerdata.com'

  class MustProvideTokenError < StandardError; end
  class TokenInvalidError < StandardError; end
  class BadConnectionToAPIError < StandardError; end

  def self.config
    @config ||= TowerData::Config.new
  end

  def self.config=(new_conf)
    @config = new_conf
  end

  def self.configure
    yield config if block_given?
    raise MustProvideTokenError, "TowerData requires a token to use the API" unless config.token
  end

  def self.get(path, options, &block)
    response = super(path, options, &block)

    #puts response

    success_codes = [200, 10, 20, 30, 40, 45, 50]
    if response['status_code'].nil? || !success_codes.include?(response['status_code'])
      raise BadConnectionToAPIError
    elsif response['status_code'] == 200 && response['status_desc'] =~ /Not authorized/
      raise TokenInvalidError
    end

    response
  end

  def self.validate_email(address)
    opts = {
      headers: @config.headers,
      query: {
        license: @config.token,
        email: address
      }
    }

    response = get('/person',opts)
    Email.new(response)
  end

  def self.validate_phone(number)
    opts = {
      headers: @config.headers,
      query: {
        license: @config.token,
        phone: number
      }
    }

    response = get('/person',opts)
    Phone.new(response)
  end

  class Email
    attr_accessor :ok, :validation_level, :status_code, :status_desc, :address, :username, :domain

    def initialize(fields)
      fields = fields['email']
      @ok = fields['ok']
      @validation_level = fields['validation_level']
      @status_code = fields['status_code']
      @status_desc = fields['status_desc']
      @address = fields['address']
      @username = fields['username']
      @domain = fields['domain']
      @timeout = @status_code == 5
    end

    def valid?
      case @status_code
      when 10, 20, 30, 40, 50
        true
      else
        false
      end
    end
  end

  class Phone
    attr_accessor :ok, :status_code, :status_desc, :number, :extension, :city, :state, :new_npa, \
      :country, :county, :latitute, :longitude, :timezone, :observes_dst, :messages, :line_type, \
      :carrier
    def initialize(fields)
      #puts fields
      fields = fields['phone']

      @ok = fields['ok']
      @status_code = fields['status_code']
      @status_desc = fields['status_desc']
      @number = fields['number']
      @extension = fields['extension']
      @city = fields['city']
      @state = fields['state']
      @new_npa = fields['new_npa']
      @country = fields['country']
      @county = fields['county']
      @latitute = fields['latitute']
      @longitude = fields['longitude']
      @timezone = fields['timezone']
      @observes_dst = fields['observes_dst']
      @messages = fields['messages']
      @line_type = fields['line_type']
      @carrier = fields['carrier']
    end
  end

  class Config

    attr_accessor :token, :headers
    def initialize(token = nil, headers = { 'Content-Type' => 'application/json' })
      @token = token
      @headers = headers
    end
  end
end
