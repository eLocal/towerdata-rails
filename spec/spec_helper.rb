require 'vcr'
require 'active_record'
require 'protected_attributes'
require './lib/tower_data.rb'
require './app/validators/validators.rb'
require './spec/test_model.rb'

RSpec.configure do |config|
  config.tty = true
  config.color_enabled = true
end

VCR.configure do |c|
  c.cassette_library_dir = 'spec/fixtures/cassettes'
  c.hook_into :webmock
end

