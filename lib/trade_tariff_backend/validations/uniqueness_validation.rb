module TradeTariffBackend
  module Validations
    class UniquenessValidation < GenericValidation
      def valid?(record = nil)
        args = validation_options[:of]

        raise ArgumentError.new("validates :uniqueness expects parameter of: Array") if args.blank?

        criteria = record.values.slice(*args)
        ds = record.model.filter(criteria)
        num_dupes = ds.count
        if num_dupes == 0
          true # No unique value in the database
        elsif num_dupes > 1
         # Multiple "unique" values in the database
          false
        elsif record.new?
         # New record, but unique value already exists in the database
          false
        else
          ds.first === record
        end
      end
    end
  end
end
