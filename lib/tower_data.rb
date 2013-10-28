# encoding: UTF-8
require 'json'
require 'tower_data/providers'

module TowerData
  class MustProvideTokenError < StandardError; end
  class TokenInvalidError < StandardError; end
  class BadConnectionToAPIError < StandardError; end
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

  def self.provider
    @provider ||= TowerData::TowerDataDefault.new
  end

  def self.provider=(new_prov)
    @provider = new_prov
  end

  # Submit a request with an email address, return a TowerData::Email object
  #
  # Arguments:
  #   address: (String)
  def self.validate_email(address)
    provider.validate_email(address)
  end

  # Submit a request with a phone number, return a TowerData::Phone object
  #
  # Arguments:
  #   number: (String)
  def self.validate_phone(number)
    provider.validate_phone(number)
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
    attr_accessor :validation_level, :address, :username, :domain, :corrections

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
    attr_accessor :number, :extension, :city, :state, :new_npa, :country, :county, :latitude, :longitude,
      :timezone, :observes_dst, :messages, :line_type, :carrier

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
    attr_accessor :token, :headers, :show_corrections, :auto_accept_corrections, :only_validate_on_change

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
      @only_validate_on_change = false
    end
  end
end
