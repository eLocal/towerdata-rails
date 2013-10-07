require 'httparty'
require 'json'

module TowerData
  include HTTParty
  base_uri 'http://api10.towerdata.com'

  class MustProvideTokenError < StandardError; end
  class TokenInvalidError < StandardError; end
  class BadConnectionToAPIError < StandardError; end
  class InvalidRequestError < StandardError; end
  class UnknownServerError < StandardError; end

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

    with_valid_response('/person',opts) do |response|
      Email.new(response)
    end
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

  def self.with_valid_response(url, opts, &block)
    response = get(url, opts)
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

  module CommonData
    attr_accessor :ok, :status_code, :status_desc

    alias :ok? :ok

    def incorrect?
      !ok?
    end

    def timeout?
      status_code == 5
    end

    protected
    def set_attributes(atts)
      unless atts.nil?
        atts.each do |k, v|
          send(:"#{k}=", v)
        end
      end
      true
    end

  end

  # A wrapper to the response from an email search request
  class Email
    attr_accessor :ok, :validation_level, :address, :username, :domain, :corrections

    include CommonData

    # Create a new TowerData::Email
    #
    # Arguments:
    #   fields: (HTTParty::Response)
    def initialize(fields)
      set_attributes fields['email']
    end
  end

  # A wrapper to the response from a phone search request
  class Phone
    include CommonData
    attr_accessor :number, :extension, :city, :state, :new_npa,
      :country, :county, :latitude, :longitude, :timezone, :observes_dst, :messages, :line_type,
      :carrier

    # Create a new TowerData::Phone
    #
    # Arguments:
    #   fields: (HTTParty::Response)
    def initialize(fields)
      set_attributes fields['phone']
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
