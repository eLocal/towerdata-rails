class TestModel < ActiveRecord::Base
  include TowerData

  attr_accessible :email

  validates :email, email: true
end
