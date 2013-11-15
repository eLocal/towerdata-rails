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

        if eligible_for_validation?(record, attribute)
          e = TowerData.validate_email(value)
          if e.incorrect?
            if e.corrections && auto_accept_corrections?
              record.send(:"#{attribute}=",  e.corrections.first)
            else
              record.errors[attribute] << custom_error_message(default_failure_message(e), e)
            end
          end
        end
      end

      private

      def eligible_for_validation?(record, attribute)
        !TowerData.config.only_validate_on_change ||
          !record.respond_to?(:"#{attribute}_changed?") ||
          record.send("#{attribute}_changed?")
      end

      def default_failure_message(e)
        rv = "did not pass TowerData validation: #{e.status_desc}"

        if show_corrections? && e.corrections
          rv << ".  Did you mean #{e.corrections.join(" or ")}?"
        end

        rv
      end

      def auto_accept_corrections?
        # could be false, so can't use ||
        if options.include?(:auto_accept_corrections)
          options[:auto_accept_corrections]
        else
          TowerData.config.auto_accept_corrections
        end
      end

      def show_corrections?
        # could be false, so can't use ||
        if options.include?(:show_corrections)
          options[:show_corrections]
        else
          TowerData.config.show_corrections
        end
      end
    end

    class TowerDataPhoneValidator < ActiveModel::EachValidator
      include CommonMethods

      def validate_each(record, attribute, value)
        return true if handle_nil?(record, attribute, value) || handle_blank?(record, attribute, value)

        p = TowerData.validate_phone(value)
        if p.incorrect?
          record.errors[attribute] << custom_error_message("did not pass TowerData validation: #{p.status_desc}", p)
        end
      end
    end
  end
end

