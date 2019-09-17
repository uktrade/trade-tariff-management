module WorkbasketInteractions
  module EditFootnote
    class InitialValidator
      ALLOWED_OPS = %w(
        reason_for_changes
        operation_date
        description
        description_validity_start_date
        validity_start_date
        validity_end_date
        commodity_codes
        measure_sids
      ).freeze

      VALIDITY_PERIOD_ERRORS_KEYS = %i[
        validity_start_date
        validity_end_date
      ].freeze

      attr_accessor :original_footnote,
                    :settings,
                    :errors,
                    :errors_summary,
                    :start_date,
                    :end_date,
                    :attrs_parser

      def initialize(original_footnote, settings)
        @errors = {}
        @original_footnote = original_footnote
        @settings = settings

        @start_date = parse_date(:validity_start_date)
        @end_date = parse_date(:validity_end_date)

        @attrs_parser = ::WorkbasketValueObjects::EditFootnote::AttributesParser.new(
          settings
        )
      end

      ALLOWED_OPS.map do |option_name|
        define_method(option_name) do
          settings[option_name]
        end
      end

      def fetch_errors
        check_reason_for_changes!
        check_description!
        check_description_validity_start_date!
        check_validity_period!
        check_commodity_codes!
        check_measures!

        errors
      end

      def errors_translator(key)
        I18n.t(:edit_footnote)[key]
      end

    private

      def check_reason_for_changes!
        if reason_for_changes.blank?
          @errors[:reason_for_changes] = errors_translator(:reason_for_changes_blank)
          @errors_summary = errors_translator(:summary_minimal_required_fields)
        end
      end

      def check_description!
        if description.blank? || (
            description.present? &&
            description.squish.split.size.zero?
          )

          @errors[:description] = errors_translator(:description_blank)
          @errors_summary = errors_translator(:summary_minimal_required_fields)
        end
      end

      def check_description_validity_start_date!
        desc_date = parse_date(:description_validity_start_date)

        if desc_date.present?
          if start_date.present?
            if end_date.present?
              if desc_date < start_date || desc_date > end_date
                @errors[:description_validity_start_date] = errors_translator(:description_validity_start_date_outside_range)
                @errors_summary = errors_translator(:summary_invalid_fields)
              end

            else
              if desc_date < start_date
                @errors[:description_validity_start_date] = errors_translator(:description_validity_start_date_outside_range)
                @errors_summary = errors_translator(:summary_invalid_fields)
              end
            end
          end

        else

          if description.present? && description_does_not_match_original_description?
            @errors[:description_validity_start_date] = errors_translator(:description_validity_start_date_blank)
            @errors_summary = errors_translator(:summary_minimal_required_fields)
          end
        end
      end

      def check_validity_period!
        if start_date.present?
          if end_date.present? && start_date > end_date
            @errors[:validity_start_date] = errors_translator(:validity_start_date_later_than_until_date)
          end

        elsif @errors[:validity_start_date].blank?
          @errors[:validity_start_date] = errors_translator(:validity_start_date_blank)
        end

        if start_date.present? &&
            end_date.present? &&
            end_date < start_date

          @errors[:validity_end_date] = errors_translator(:validity_end_date_earlier_than_start_date)
        end

        if VALIDITY_PERIOD_ERRORS_KEYS.any? do |error_key|
             errors.has_key?(error_key)
           end

          @errors_summary = errors_translator(:summary_invalid_fields) if @errors_summary.blank?
        end
      end

      def check_commodity_codes!
        return unless can_add_commodity_code?

        if commodity_codes.present? && !commodity_codes_are_invalid?
          list = attrs_parser.parse_list_of_values(commodity_codes)

          if list.present?
            db_list = GoodsNomenclature.where(goods_nomenclature_item_id: list)
                                       .distinct(:goods_nomenclature_item_id)

            if db_list.count < list.count
              @errors[:commodity_codes] = errors_translator(:commodity_codes_not_recognised)
              @errors_summary = errors_translator(:summary_invalid_fields)
            end
          end
        end

        if commodity_codes_are_invalid?
          @errors[:commodity_codes] = errors_translator(:commodity_codes_not_recognised)
        end
      end

      def commodity_codes_are_invalid?
        valid_codes = commodity_codes.split(', ').map do |code|
          code.length == 10 && code_contains_only_integers?(code)
        end

        valid_codes.include? false
      end

      def check_measures!
        return unless can_add_measures?

        if measure_sids.present? && !measure_sids_are_invalid?
          list = attrs_parser.parse_list_of_values(measure_sids)

          if list.present?
            db_list = Measure.where(measure_sid: list)
                             .distinct(:measure_sid)

            if db_list.count < list.count
              @errors[:measure_sids] = errors_translator(:measures_not_recognised)
              @errors_summary = errors_translator(:summary_invalid_fields)
            end
          end
        end

        if measure_sids_are_invalid?
          @errors[:measure_sids] = errors_translator(:measures_not_recognised)
        end
      end

      def measure_sids_are_invalid?
        valid_sids = measure_sids.split(', ').map do |sid|
          sid.length == 7 && code_contains_only_integers?(sid)
        end

        valid_sids.include? false
      end

      def parse_date(option_name)
        date_in_string = public_send(option_name)

        begin
          Date.strptime(date_in_string, "%d/%m/%Y")
        rescue Exception => e
          if date_in_string.present?
            @errors[option_name] = errors_translator("#{option_name}_wrong_format".to_sym)
          end

          nil
        end
      end

      def code_contains_only_integers?(code)
        code.scan(/\D/).empty?
      end

      def can_add_commodity_code?
        ['NC', 'PN', 'TN'].include?(original_footnote.footnote.footnote_type_id)
      end

      def can_add_measures?
        ['CD','CG','DU','EU','IS','MG','MX','OZ','PB','TM','TR'].include?(original_footnote.footnote.footnote_type_id)
      end

      def description_does_not_match_original_description?
        description.squish != original_footnote.description.squish
      end
    end
  end
end
