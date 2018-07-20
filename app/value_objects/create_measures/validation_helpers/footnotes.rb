module CreateMeasures
  module ValidationHelpers
    class Footnotes < ::CreateMeasures::ValidationHelpers::AssociationBase

      attr_accessor :measure,
                    :current_admin,
                    :operation_date,
                    :footnote_description,
                    :footnote_type_id,
                    :footnote,
                    :footnote_association_measure,
                    :footnote_description_period,
                    :footnote_description,
                    :extra_increment_value,
                    :period_sid,
                    :errors

      def initialize(measure, system_ops, footnote_ops={})
        @measure = measure
        @current_admin = system_ops[:current_admin]
        @operation_date = system_ops[:operation_date]
        @footnote_description = footnote_ops[:description]
        @footnote_type_id = footnote_ops[:footnote_type_id]
        @extra_increment_value = footnote_ops[:position]

        @errors = {}
      end

      def valid?
        generate_records!
        validate_records!

        if @errors.blank? && !measure.new?
          persist!
        end

        @errors.blank?
      end

      def persist!
        records.map do |record|
          persist_record!(record)
        end
      end

      private

        def generate_records!
          generate_footnote!
          generate_footnote_association_measure!
          generate_footnote_description_period!
          generate_footnote_description!
        end

        def records
          [
            footnote,
            footnote_association_measure,
            footnote_description_period,
            footnote_description
          ]
        end

        def validate_records!
          records.map do |record|
            validate!(record)
          end
        end

        def generate_footnote!
          @footnote = Footnote.new(
            validity_start_date: measure.validity_start_date,
            validity_end_date: measure.validity_end_date
          )
          footnote.footnote_type_id = footnote_type_id

          set_primary_key(footnote)
        end

        def generate_footnote_association_measure!
          @footnote_association_measure = FootnoteAssociationMeasure.new

          footnote_association_measure.measure_sid = measure.measure_sid
          footnote_association_measure.footnote_id = footnote.footnote_id
          footnote_association_measure.footnote_type_id = footnote_type_id
        end

        def generate_footnote_description_period!
          @footnote_description_period = FootnoteDescriptionPeriod.new(
            validity_start_date: footnote.validity_start_date,
            validity_end_date: footnote.validity_end_date
          )

          footnote_description_period.footnote_id = footnote.footnote_id
          footnote_description_period.footnote_type_id = footnote_type_id

          set_primary_key(footnote_description_period)
          @period_sid = footnote_description_period.footnote_description_period_sid

          footnote.footnote_description_periods << footnote_description_period
        end

        def generate_footnote_description!
          @footnote_description = FootnoteDescription.new(
            language_id: DEFAULT_LANGUAGE,
            description: footnote_description
          )

          footnote_description.footnote_id = footnote.footnote_id
          footnote_description.footnote_type_id = footnote_type_id
          footnote_description.footnote_description_period_sid = period_sid
        end

        def validate!(record)
          if validator(record.class.name).present?
            ::Measures::ConformanceErrorsParser.new(
              record, validator(record.class.name), {}
            ).errors
             .map do |k, v|
              @errors[k] = v
            end
          end
        end

        def validator(klass_name)
          case klass_name
          when "Footnote"
            FootnoteValidator
          when "FootnoteDescription"
            FootnoteDescriptionValidator
          when "FootnoteDescriptionPeriod"
            FootnoteDescriptionPeriodValidator
          end
        end
    end
  end
end
