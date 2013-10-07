# encoding: UTF-8
require 'spec_helper'

include TowerData

describe "TowerData::Validators" do
  context 'EmailValidator' do
    it 'rejects a record with an invalid address'
    it 'accepts a record with a valid address'
  end

  context 'PhoneValidator' do
    it 'rejects a record with an invalid number'
    it 'accepts a record with a valid number'
  end
end
