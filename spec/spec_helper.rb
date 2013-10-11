require 'bundler'
Bundler.require(:default)

require 'vcr'
require 'webmock/rspec'
require './spec/test_model.rb'

RSpec.configure do |config|
  config.tty = true
  config.color_enabled = true
end

VCR.configure do |c|
  c.cassette_library_dir = 'spec/fixtures/cassettes'
  c.allow_http_connections_when_no_cassette = true
  c.hook_into :webmock
end

