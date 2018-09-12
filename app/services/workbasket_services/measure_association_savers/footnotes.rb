module WorkbasketServices
  module MeasureAssociationSavers
    class Footnotes < ::WorkbasketServices::MeasureAssociationSavers::MultipleAssociation

      attr_accessor :measure,
                    :system_ops,
                    :footnote_description,
                    :footnote_type_id,
                    :footnote,
                    :footnote_association_measure,
                    :footnote_description_period,
                    :footnote_description,
                    :footnote_reuse,
                    :extra_increment_value,
                    :period_sid,
                    :errors

      def initialize(measure, system_ops, footnote_ops={})
        @measure = measure
        @system_ops = system_ops
        @footnote_description = footnote_ops[:description]
        @footnote_type_id = footnote_ops[:footnote_type_id]
        @extra_increment_value = footnote_ops[:position]

        @errors = {}
      end

      def persist!
        unless footnote_reuse.present?
          persist_record!(footnote_description_period)
          persist_record!(footnote)
          persist_record!(footnote_description)
          swap_workbasket_sequence_number(footnote_description_period, footnote)
        end

        persist_record!(footnote_association_measure)
      end

      def swap_workbasket_sequence_number(record1, record2)
        sequence_number1 = record1.workbasket_sequence_number
        sequence_number2 = record2.workbasket_sequence_number
        record2.workbasket_sequence_number = sequence_number1
        record2.save
        record1.workbasket_sequence_number = sequence_number2
        record1.save
      end

      private

        def generate_records!
          generate_footnote!
          generate_footnote_association_measure!

          unless footnote_reuse.present?
            generate_footnote_description_period!
            generate_footnote_description!
          end
        end

        def validate_records!
          unless footnote_reuse.present?
            validate!(footnote)
            validate!(footnote_description_period)
            validate!(footnote_description)
          end

          validate!(footnote_association_measure)
        end

        def generate_footnote!
          footnote_desc = FootnoteDescription.where(
            footnote_type_id: footnote_type_id,
            description: footnote_description
          ).first

          if footnote_desc.present?
            @footnote = Footnote.where(
              footnote_type_id: footnote_type_id,
              footnote_id: footnote_desc.footnote_id
            ).first
          end

          if @footnote.present?
            @footnote_reuse = true
          else
            @footnote = Footnote.new(
              validity_start_date: measure.validity_start_date,
              validity_end_date: measure.validity_end_date
            )
            footnote.footnote_type_id = footnote_type_id

            set_primary_key(footnote)
          end
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
