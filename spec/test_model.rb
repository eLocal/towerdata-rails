require 'tower_data/validators'
class EmailTestModel
  include ActiveModel::Model
  include ActiveModel::Validations
  include TowerData::Validators

  attr_accessor :email

  validates :email, tower_data_email: true
end

class EmailTestModelStringErrorMessages
  include ActiveModel::Model
  include ActiveModel::Validations
  include TowerData::Validators

  attr_accessor :email

  validates :email, tower_data_email: { message: "String message with status" }
end

class EmailTestModelAllowBlank
  include ActiveModel::Model
  include ActiveModel::Validations
  include TowerData::Validators

  attr_accessor :email

  validates :email, tower_data_email: { allow_blank: true }
end

class EmailTestModelAllowNil
  include ActiveModel::Model
  include ActiveModel::Validations
  include TowerData::Validators

  attr_accessor :email

  validates :email, tower_data_email: { allow_nil: true }
end

class EmailTestModelProcErrorMessages
  include ActiveModel::Model
  include ActiveModel::Validations
  include TowerData::Validators

  attr_accessor :email

  validates :email, tower_data_email: { message: Proc.new{|e| "Proc message with status #{e.status_desc}" } }
end

class EmailTestModelValidOnChange
  include ActiveModel::Model
  include ActiveModel::Validations
  include ActiveModel::Dirty
  include TowerData::Validators

  define_attribute_methods :email

  def email
    @email
  end

  def email=(val)
    email_will_change! unless val == @email
    @email = val
  end

  def save
    @changed_attributes = {}
  end

  validates :email, tower_data_email: true
end

class PhoneTestModelStringErrorMessages
  include ActiveModel::Model
  include ActiveModel::Validations
  include TowerData::Validators

  attr_accessor :phone

  validates :phone, tower_data_phone: { message: "String message with status" }
end

class PhoneTestModelProcErrorMessages
  include ActiveModel::Model
  include ActiveModel::Validations
  include TowerData::Validators

  attr_accessor :phone

  validates :phone, tower_data_phone: { message: Proc.new{|e| "Proc message with status #{e.status_desc}" } }
end

class PhoneTestModelAllowNil
  include ActiveModel::Model
  include ActiveModel::Validations
  include TowerData::Validators

  attr_accessor :phone

  validates :phone, tower_data_phone: { allow_nil: true }
end

class PhoneTestModelAllowBlank
  include ActiveModel::Model
  include ActiveModel::Validations
  include TowerData::Validators

  attr_accessor :phone

  validates :phone, tower_data_phone: { allow_blank: true }
end

class PhoneTestModel
  include ActiveModel::Model
  include ActiveModel::Validations
  include TowerData::Validators

  attr_accessor :phone

  validates :phone, tower_data_phone: true
end
