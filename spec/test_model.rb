require 'tower_data/validators'
class EmailTestModel
  include ActiveModel::Model
  include ActiveModel::Validations
  include TowerData::Validators

  attr_accessor :email

  validates :email, email: true
end

class PhoneTestModel
  include ActiveModel::Model
  include ActiveModel::Validations
  include TowerData::Validators

  attr_accessor :phone

  validates :phone, phone: true
end
