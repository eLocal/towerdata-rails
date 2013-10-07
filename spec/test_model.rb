class EmailTestModel
  include ActiveModel::Model
  include ActiveModel::Validations
  include TowerData

  attr_accessor :email

  validates :email, email: true
end

class PhoneTestModel
  include ActiveModel::Model
  include ActiveModel::Validations
  include TowerData

  attr_accessor :phone

  validates :phone, phone: true
end
