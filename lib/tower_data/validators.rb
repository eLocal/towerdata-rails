require 'active_model'
require 'tower_data'
module TowerData
  module Validators
    module CommonMethods
      def custom_error_message(default_msg, td_object, options_value = :message)
        if options[options_value]
          if options[options_value].is_a?(Proc)
            options[options_value].call(td_object)
          else
            options[options_value]
          end
        else
          default_msg
        end
      end

      [:nil, :blank].each do |t|
        define_method :"handle_#{t}?" do |record, attribute, value|
          if value.send(:"#{t}?")
            record.errors[attribute] << custom_error_message('may not be blank', nil) \
              unless options[:"allow_#{t}"]
            true
          else
            false
          end
        end
      end
    end

    class TowerDataEmailValidator < ActiveModel::EachValidator
      include CommonMethods
      def validate_each(record, attribute, value)
        return true if handle_nil?(record, attribute, value) || handle_blank?(record, attribute, value)

        if !TowerData.config.only_validate_on_change || record.send("#{attribute}_changed?")
          e = TowerData.validate_email(value)
          if e.incorrect?
            if e.corrections
              if TowerData.config.auto_accept_corrections
                record.email = e.corrections.first
              else
                record.errors[attribute] << custom_error_message("Did not pass TowerData validation: #{e.status_desc}", e)

                record.errors[attribute] << custom_error_message("Possible corrections: #{e.corrections}", e, :correction_message) if options[:show_corrections] || TowerData.config.show_corrections
              end
            else
              record.errors[attribute] << custom_error_message("Did not pass TowerData validation: #{e.status_desc}", e)
            end
          end
        end
      end
    end

    class TowerDataPhoneValidator < ActiveModel::EachValidator
      include CommonMethods

      def validate_each(record, attribute, value)
        return true if handle_nil?(record, attribute, value) || handle_blank?(record, attribute, value)

        p = TowerData.validate_phone(value)
        if p.incorrect?
          record.errors[attribute] << custom_error_message("Did not pass TowerData validation: #{p.status_desc}", p)
        end
      end
    end
  end
end

