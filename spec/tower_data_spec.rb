# encoding: UTF-8
require 'spec_helper'

include TowerData

describe "TowerData" do

  context 'raises errors' do
    it 'on bad responses from the API' do

    end

    it 'on invalid config tokens' do
      VCR.use_cassette('bad_token') do
        TowerData.configure do |c|
          c.token = 'bad_token'
        end

        expect {
          TowerData.validate_email('email@address.com')
        }.to raise_error(TokenInvalidError)
      end
    end

    it 'handles missing config values' do
      expect {
        TowerData.configure do |c|
          c.token = nil
        end
      }.to raise_error(MustProvideTokenError)
    end
  end

  context 'email address' do
    before(:each) do
      TowerData.configure do |c|
        c.token = 'XXXXXXXXXX'
      end
    end

    context 'valid' do
      it 'returns a success code' do
        VCR.use_cassette('valid_email') do
          e = TowerData.validate_email('andrew.fallows@elocal.com')
          e.status_code.should be 45
          e.ok.should eq true
        end
      end
    end

    context 'invalid' do
      it 'returns a failure code' do
        VCR.use_cassette('invalid_email') do
          e = TowerData.validate_email('not_an_address')
          e.status_code.should be 150
          e.ok.should eq false
        end
      end
    end

    context 'correctable' do
      it 'provides the original value and the suggested correction'
    end
  end

  context 'phone number' do
    before(:each) do
      TowerData.configure do |c|
        c.token = 'XXXXXXXXXX'
      end
    end

    context 'valid' do
      it 'returns a success code' do
        VCR.use_cassette('valid_phone') do
          p = TowerData.validate_phone('888-227-8255')
          p.status_code.should be 10
          p.ok.should be true
        end
      end
    end

    context 'invalid' do
      it 'returns a failure code' do
        VCR.use_cassette('invalid_phone') do
          p = TowerData.validate_phone('5')
          p.status_code.should be 120
          p.ok.should be false
        end
      end
    end
  end
end
