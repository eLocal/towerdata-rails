# encoding: UTF-8
require 'spec_helper'

include TowerData

describe "TowerData::Validators" do
  context 'EmailValidator' do
    before(:each) do
      TowerData.configure do |c|
        c.token = 'McqFUiR5a9'
      end
    end

    it 'rejects a record with an invalid address' do
      VCR.use_cassette('validate_bad_email') do
        m = EmailTestModel.new
        m.email = 'bad_email_address'
        m.should_not be_valid
      end
    end

    it 'accepts a record with a valid address' do
      VCR.use_cassette('validate_good_email') do
        m = EmailTestModel.new
        m.email = 'andrew.fallows@elocal.com'
        m.should be_valid
      end
    end
  end

  context 'PhoneValidator' do
    it 'rejects a record with an invalid number' do
      VCR.use_cassette('validate_bad_phone') do
        m = PhoneTestModel.new
        m.phone = 'notaphone'
        m.should_not be_valid
      end
    end

    it 'accepts a record with a valid number' do
      VCR.use_cassette('validate_good_phone') do
        m = PhoneTestModel.new
        m.phone = '888-227-8255'
        m.should be_valid
      end
    end
  end
end
