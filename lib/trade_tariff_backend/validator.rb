require 'trade_tariff_backend/validator/validation_definer'
require 'trade_tariff_backend/validator/validation_error'

module TradeTariffBackend
  class Validator
    def self.validations
      @validations ||= []
      @validations
    end

    def self.validation(identifiers, description, opts = {}, &block)
      validations << ValidationDefiner.define(identifiers, description, opts, &block)
    end

    def validations
      self.class.validations
    end

    def validate(record)
      relevant_validations_for(record).select { |validation|
        validation.operations.include?(record.operation)
      }.each { |validation|
        unless validation.valid?(record)
          message =  if validation.options[:extend_message].present?
                       [validation.to_s, validation.options[:extend_message].call(record)].compact.join(" ")
                     elsif validation.validation_options[:extend_message] == true
                       [validation.to_s, validation.extend_error_message(record)].compact.join(" ")
                     else
                       validation.to_s
                     end

          record.conformance_errors.add(validation.identifiers, message)
        end
      }
    end

    def validate_for_operations(record, *operations)
      relevant_validations_for(record).select { |validation|
        (validation.operations & operations).any?
      }.each { |validation|
        record.conformance_errors.add(validation.identifiers, validation.to_s) unless validation.valid?(record)
      }
    end

    private

    def relevant_validations_for(record)
      validations.select { |validation|
        validation.relevant_for?(record)
      }
    end
  end
end
