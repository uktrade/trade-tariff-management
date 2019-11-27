module WorkbasketInteractions
  module CreateNomenclature
    class InitialValidator
      ALLOWED_OPS = %w(
        description
        validity_start_date
      ).freeze

      VALIDITY_PERIOD_ERRORS_KEYS = %i[
        validity_start_date
        validity_end_date
      ].freeze

      attr_accessor :settings,
                    :errors,
                    :errors_summary,
                    :start_date

      def initialize(settings)
        @errors = {}
        @settings = settings

      end

      ALLOWED_OPS.map do |option_name|
        define_method(option_name) do
          settings[option_name]
        end
      end

      def fetch_errors
        check_description!
        check_validity_period!
        check_origin!
        check_indents!
        check_section_and_chapter!

        errors
      end

      def errors_translator(key)
        I18n.t(:create_nomenclature)[key]
      end

    private

      def check_description!
        if settings.description.blank? || (
            settings.description.present? &&
            settings.description.squish.split.size.zero?
          )

          @errors[:description] = errors_translator(:description_blank)
          @errors_summary = errors_translator(:summary_minimal_required_fields)
        end
      end

      def check_validity_period!
        if settings.validity_start_date.present?
          if settings.validity_start_date <= Date.today
            @errors[:validity_start_date] = "Start date must be after today's date."
          end
        elsif @errors[:validity_start_date].blank?
          @errors[:validity_start_date] = errors_translator(:validity_start_date_blank)
        end

        if VALIDITY_PERIOD_ERRORS_KEYS.any? do |error_key|
             errors.has_key?(error_key)
           end

          @errors_summary = errors_translator(:summary_invalid_validity_period) if @errors_summary.blank?
        end
      end

      def check_origin!

        origin_nomenclature = GoodsNomenclature.where(goods_nomenclature_item_id: settings[:origin_nomenclature], producline_suffix: settings[:origin_producline_suffix]).first
        if origin_nomenclature.nil? ||
          origin_nomenclature.validity_start_date > settings.validity_start_date ||
          ( origin_nomenclature.validity_end_date != nil && settings.validity_start_date > origin_nomenclature.validity_end_date )

          @errors[:origin_code] = errors_translator(:origin_code_not_valid)
          @errors[:origin_producline_suffix] = errors_translator(:origin_code_not_valid)
          @errors_summary = errors_translator(:origin_code_not_valid)
        end
      end

      def check_section_and_chapter!
        unless chapter_exists_for_nomenclature?(settings.goods_nomenclature_item_id)
          @errors[:goods_nomenclature_item_id] = errors_translator(:chapter_doesnt_exist)
          @errors_summary = errors_translator(:chapter_doesnt_exist)
        end
      end

      def chapter_exists_for_nomenclature?(goods_nomenclature_item_id)
        # check if an item exists using the first 4 characters - this will correspond to the section chapter
        section_chapter = GoodsNomenclature.actual(include_future: true).where(goods_nomenclature_item_id: goods_nomenclature_item_id.first(4).ljust(10, '0'), status: 'published').first
        section_chapter.present?
      end

      def check_indents!
        if settings.number_indents < 1
          @errors[:number_indents] = errors_translator(:indents_must_be_greater_than_zero)
          @errors_summary = errors_translator(:indents_must_be_greater_than_zero)
        end
      end

    end
  end
end
