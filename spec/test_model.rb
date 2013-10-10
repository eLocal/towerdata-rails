require 'tower_data/validators'
class EmailTestModel
  include ActiveModel::Model
  include ActiveModel::Validations
  include TowerData::Validators

  attr_accessor :email

  validates :email, tower_data_email: true
end

class PhoneTestModel
  include ActiveModel::Model
  include ActiveModel::Validations
  include TowerData::Validators

  attr_accessor :phone

  validates :phone, tower_data_phone: true
end
