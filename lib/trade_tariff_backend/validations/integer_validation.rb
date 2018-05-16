module TradeTariffBackend
  module Validations
    class IntegerValidation < GenericValidation
      def valid?(record = nil)
        args = validation_options[:of]

        raise ArgumentError.new("validates presence expects of:[Array] to be passed in") if args.blank?

        [args].flatten.all? do |arg|
          val = record.send(arg.to_sym)

          val.blank? || (
            val.present? && val.is_a?(Integer)
          )
        end
      end
    end
  end
end
