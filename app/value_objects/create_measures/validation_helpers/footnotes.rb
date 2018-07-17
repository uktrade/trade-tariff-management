module CreateMeasures
  module ValidationHelpers
    class Footnotes < ::CreateMeasures::ValidationHelpers::Base

      attr_accessor :measure,
                    :footnote_description,
                    :footnote_type_id,
                    :footnote,
                    :footnote_association_measure,
                    :footnote_description_period,
                    :footnote_description,
                    :period_sid,
                    :errors

      def initialize(measure, footnote_ops)
        @measure = measure
        @footnote_description = footnote_ops[:description]
        @footnote_type_id = footnote_ops[:footnote_type_id]

        @errors = {}
      end

      def valid?
        check_footnote!
        return false if @errors.blank?

        check_footnote_association_measure!
        return false if @errors.blank?

        check_footnote_description_period!
        return false if @errors.blank?

        check_footnote_description!
        @errors.blank?
      end

      private

        def check_footnote!
          @footnote = Footnote.new(
            validity_start_date: measure.validity_start_date,
            validity_end_date: measure.validity_end_date
          )
          footnote.footnote_type_id = footnote_type_id

          set_primary_key(footnote)
        end

        def check_footnote_association_measure!
          @footnote_association_measure = FootnoteAssociationMeasure.new

          footnote_association_measure.measure_sid = measure.measure_sid
          footnote_association_measure.footnote_id = footnote.footnote_id
          footnote_association_measure.footnote_type_id = footnote_type_id

          set_primary_key(footnote_association_measure)
        end

        def check_footnote_description_period!
          @footnote_description_period = FootnoteDescriptionPeriod.new(
            validity_start_date: footnote.validity_start_date,
            validity_end_date: footnote.validity_end_date
          )

          footnote_description_period.footnote_id = footnote.footnote_id
          footnote_description_period.footnote_type_id = footnote_type_id

          set_primary_key(footnote_description_period)
          @period_sid = footnote_description_period.footnote_description_period_sid
        end

        def check_footnote_description!
          @footnote_description = FootnoteDescription.new(
            language_id: DEFAULT_LANGUAGE,
            description: footnote_description
          )

          footnote_description.footnote_id = footnote.footnote_id
          footnote_description.footnote_type_id = footnote_type_id
          footnote_description.footnote_description_period_sid = period_sid

          set_primary_key(footnote_description)
        end
    end
  end
end
