module TowerData
  class EmailValidator < ActiveModel::EachValidator
    def validate_each(record, attribute, value)
      e = TowerData.validate_email(value)
      unless e.valid?
        record.errors[attribute] << "Did not pass TowerData validation: #{e.status_desc}"
      end
    end
  end

  class PhoneValidator < ActiveModel::EachValidator
    def validate_each(record, attribute, value)
      p = TowerData.validate_phone(value)
      unless p.valid?
        record.errors[attribute] << "Did not pass TowerData validation: #{p.status_desc}"
      end
    end
  end
end

