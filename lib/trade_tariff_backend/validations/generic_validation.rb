module TradeTariffBackend
  module Validations
    class GenericValidation
      DEFAULT_OPERATIONS = %i[create update destroy].freeze

      attr_reader :identifiers, :description,
                  :options, :operations, :validation_block,
                  :validation_options

      def initialize(identifiers, description, options = {}, &validation_block)
        @identifiers = identifiers
        @description = description
        @validation_block = validation_block
        @validation_options = options.delete(:validation_options)
        @options = options

        self.operations = @options.fetch(:on, DEFAULT_OPERATIONS)
      end

      def validation_options
        @validation_options || {}
      end

      def operations=(operation_list)
        raise ArgumentError.new("Valid validation operations are: #{DEFAULT_OPERATIONS}") if (operation_list - DEFAULT_OPERATIONS).any?

        @operations = operation_list
      end

      def valid?(record = nil)
        validation_block.call(record) != false
      end

      def type
        @type ||= self.class.name.demodulize.split("Validation").first.underscore.to_sym
      end

      def relevant_for?(record)
        !options.has_key?(:if) ||
          (options[:if].is_a?(Proc) &&
           options[:if].call(record))
      end

      def to_s
        description
      end

      def extend_error_message(record)
        # This is not place to keep this method here.
        # Mostly this method is related to validity date span
        # validation. Might need to move into that class.

        association_key = validation_options[:of]

        if association_key
          association = record.send(association_key)

          primary_key = association.send(:primary_key)
          primary_key_value = association.send(primary_key)
          validity_period = association.send(:own_validity_period)

          "(#{association_key}-#{primary_key_value}: [#{validity_period}])"
        end
      end
    end
  end
end
