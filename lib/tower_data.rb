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

  # Follow up the default HTTParty get request with check against API errors
  #
  # Arguments:
  #   path: (String)
  #   options: (Hash)
  def self.get(path, options, &block)
    response = super(path, options, &block)

    success_codes = [200, 10, 20, 30, 40, 45, 50]

    # response['status_code'] is the code for the whol request, not the individual search(es)
    if response['status_code'].nil? || !success_codes.include?(response['status_code'])
      raise BadConnectionToAPIError
    elsif response['status_code'] == 200 && response['status_desc'] =~ /Not authorized/
      raise TokenInvalidError
    end

    response
  end

  # Submit a request with an email address, return a TowerData::Email object
  #
  # Arguments:
  #   address: (String)
  def self.validate_email(address)
    opts = {
      headers: @config.headers,
      query: {
        license: @config.token,
        correct: 'email',
        email: address
      }
    }

    response = get('/person',opts)
    Email.new(response)
  end

  # Submit a request with a phone number, return a TowerData::Phone object
  #
  # Arguments:
  #   number: (String)
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

  # A wrapper to the response from an email search request
  class Email
    attr_accessor :ok, :validation_level, :status_code, :status_desc, :address, :username, :domain, \
      :corrections

    # Create a new TowerData::Email
    #
    # Arguments:
    #   fields: (HTTParty::Response)
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
      @corrections = fields['corrections']
    end
  end

  # A wrapper to the response from a phone search request
  class Phone
    attr_accessor :ok, :status_code, :status_desc, :number, :extension, :city, :state, :new_npa, \
      :country, :county, :latitute, :longitude, :timezone, :observes_dst, :messages, :line_type, \
      :carrier

    # Create a new TowerData::Phone
    #
    # Arguments:
    #   fields: (HTTParty::Response)
    def initialize(fields)
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

  # Stores config values used in making API calls
  class Config
    attr_accessor :token, :headers, :show_corrections, :auto_accept_corrections

    # Create a new TowerData::Config. MUST provide a valid API token
    #
    # Arguments:
    #   token: (String)
    #   headers: (Hash)
    def initialize(token = nil, headers = { 'Content-Type' => 'application/json' })
      @token = token
      @headers = headers
      @show_corrections = true
      @auto_accept_corrections = false
    end
  end
end
