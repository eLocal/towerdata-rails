require 'tower_data'
module TowerData
  module Validators
    class EmailValidator < ActiveModel::EachValidator
      def validate_each(record, attribute, value)
        e = TowerData.validate_email(value)
        if e.incorrect?
          if e.corrections
            if TowerData.config.auto_accept_corrections
              record.email = e.corrections.first
            else
              record.errors[attribute] << "Did not pass TowerData validation: #{e.status_desc}"
              record.errors[attribute] << "\nPossible corrections: #{e.corrections}" if TowerData.config.show_corrections
            end
          else
            record.errors[attribute] << "Did not pass TowerData validation: #{e.status_desc}"
          end
        end
      end
    end

    class PhoneValidator < ActiveModel::EachValidator
      def validate_each(record, attribute, value)
        p = TowerData.validate_phone(value)
        if p.incorrect?
          record.errors[attribute] << "Did not pass TowerData validation: #{p.status_desc}"
        end
      end
    end
  end
end

