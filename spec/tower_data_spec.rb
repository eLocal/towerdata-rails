require 'spec_helper'

include TowerData

describe "TowerData" do
  before(:each) do
    TowerData.configure do |c|
      c.token = 'good_token'
    end
  end

  context 'raises errors' do
    it 'on bad responses from the API' do

    end

    it 'on invalid config tokens' do
      TowerData.configure do |c|
        c.token = 'bad_token'
      end

      expect {
        TowerData.validate_email('email@address.com')
      }.to raise_error(TokenInvalidError)
    end

  end
  it 'handles missing config values'

  context 'email address' do
    context 'valid' do
      it 'returns a success code'
    end

    context 'invalid' do
      it 'returns a failure code'
    end

    context 'correctable' do
      it 'provides the original value and the suggested correction'
    end
  end

  context 'phone number' do
    context 'valid' do

    end

    context 'invalid' do

    end

    context 'correctable' do

    end
  end
end
