# encoding: UTF-8
require 'spec_helper'

include TowerData

describe "TowerData::Validators" do
  context 'EmailValidator' do
    before(:each) do
      TowerData.configure do |c|
        c.token = 'XXXXXXXXXX'
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

    context 'corrections' do
      it 'reports possible corrections by default' do
        VCR.use_cassette('correction_default') do
          m = EmailTestModel.new
          m.email = 'john.doe@gmial.com'
          m.should_not be_valid
          m.errors.messages[:email].count.should be 2
        end
      end

      it 'hides correction report if show_corrections is false' do
        TowerData.configure do |c|
          c.show_corrections = false
        end

        VCR.use_cassette('correction_no_show') do
          m = EmailTestModel.new
          m.email = 'john.doe@gmial.com'
          m.should_not be_valid
          m.errors.messages[:email].count.should be 1
        end
      end

      it 'accepts a correction if auto_accept_corrections is true' do
        TowerData.configure do |c|
          c.auto_accept_corrections = true
        end

        VCR.use_cassette('correction_auto_accept') do
          m = EmailTestModel.new
          m.email = 'john.doe@gmial.com'
          m.should be_valid
        end
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
