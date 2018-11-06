module WorkbasketInteractions
  module EditFootnote
    class SettingsSaver

      include ::WorkbasketHelpers::SettingsSaverHelperMethods

      ATTRS_PARSER_METHODS = %w(
        reason_for_changes
        operation_date
        description
        description_validity_start_date
        validity_start_date
        validity_end_date
        commodity_codes
        measure_sids
      )

      attr_accessor :current_step,
                    :save_mode,
                    :settings,
                    :workbasket,
                    :settings_params,
                    :errors,
                    :conformance_errors,
                    :errors_summary,
                    :attrs_parser,
                    :initial_validator,
                    :original_footnote,
                    :footnote,
                    :footnote_description,
                    :footnote_description_period,
                    :next_footnote_description,
                    :next_footnote_description_period,
                    :commodity_codes_candidates,
                    :measures_candidates,
                    :persist

      def initialize(workbasket, current_step, save_mode, settings_ops={})
        @workbasket = workbasket
        @save_mode = save_mode
        @current_step = current_step
        @settings = workbasket.settings
        @original_footnote = settings.original_footnote.decorate
        @settings_params = ActiveSupport::HashWithIndifferentAccess.new(settings_ops)

        setup_attrs_parser!
        clear_cached_sequence_number!

        @persist = true # For now it always true
        @errors = {}
        @conformance_errors = {}
        @commodity_codes_candidates = []
        @measures_candidates = []
      end

      def save!
        workbasket.title = original_footnote.title
        workbasket.operation_date = (Date.strptime(operation_date, "%d/%m/%Y") rescue nil)
        workbasket.save

        settings.set_settings_for!(current_step, settings_params)
      end

      def valid?
        validate!
        errors.blank? && conformance_errors.blank?
      end

      def persist!
        @do_not_rollback_transactions = true
        validate!
      end

      def success_ops
        {}
      end

      ATTRS_PARSER_METHODS.map do |option|
        define_method(option) do
          attrs_parser.public_send(option)
        end
      end

      private

        def validate!
          check_initial_validation_rules!
          check_if_nothing_changed! if @errors.blank?
          check_conformance_rules! if @errors.blank?
        end

        def check_initial_validation_rules!
          @initial_validator = ::WorkbasketInteractions::EditFootnote::InitialValidator.new(
            original_footnote, settings_params
          )

          @errors = initial_validator.fetch_errors
          @errors_summary = initial_validator.errors_summary
        end

        def check_if_nothing_changed!
          if nothing_changed?
            @errors[:general] = "Nothing changed"
            @errors_summary = initial_validator.errors_translator(:nothing_changed)
          end
        end

        def nothing_changed?
          original_footnote.description.to_s.squish == description.to_s.squish &&
          original_footnote.validity_start_date.strftime("%Y-%m-%d") == validity_start_date.try(:strftime, "%Y-%m-%d") &&
          original_footnote.validity_end_date.try(:strftime, "%Y-%m-%d") == validity_end_date.try(:strftime, "%Y-%m-%d") &&
          original_footnote.commodity_codes == commodity_codes &&
          original_footnote.measure_sids == measure_sids
        end

        def check_conformance_rules!
          Sequel::Model.db.transaction(@do_not_rollback_transactions.present? ? {} : { rollback: :always }) do

            if it_is_just_description_changed?
              end_date_existing_footnote_description_period!
              add_next_footnote_description_period!
              add_next_footnote_description!

            else
              end_date_existing_footnote!

              add_footnote!
              add_footnote_description_period!
              add_footnote_description!

              if description_should_be_changed_later?
                add_next_footnote_description_period!
                add_next_footnote_description!
              end

              end_date_existing_commodity_codes_associations!
              if commodity_codes.present?
                add_new_commodity_codes_associations!
              end

              add_new_measures_associations! if measure_sids.present?
            end

            parse_and_format_conformance_rules
          end
        end

        def parse_and_format_conformance_rules
          @conformance_errors = {}

          if it_is_just_description_changed?
            unless next_footnote_description_period.conformant?
              @conformance_errors.merge!(get_conformance_errors(next_footnote_description_period))
            end

            unless next_footnote_description.conformant?
              @conformance_errors.merge!(get_conformance_errors(next_footnote_description))
            end

          else
            unless footnote.conformant?
              @conformance_errors.merge!(get_conformance_errors(footnote))
            end

            unless footnote_description_period.conformant?
              @conformance_errors.merge!(get_conformance_errors(footnote_description_period))
            end

            unless footnote_description.conformant?
              @conformance_errors.merge!(get_conformance_errors(footnote_description))
            end

            if description_should_be_changed_later?
              unless next_footnote_description_period.conformant?
                @conformance_errors.merge!(get_conformance_errors(next_footnote_description_period))
              end

              unless next_footnote_description.conformant?
                @conformance_errors.merge!(get_conformance_errors(next_footnote_description))
              end
            end

            if commodity_codes_candidates.present?
              commodity_codes_candidates.map do |item|
                unless item.conformant?
                  @conformance_errors.merge!(get_conformance_errors(item))
                end
              end
            end

            if measures_candidates.present?
              measures_candidates.map do |item|
                unless item.conformant?
                  @conformance_errors.merge!(get_conformance_errors(item))
                end
              end
            end
          end

          if conformance_errors.present?
            @errors_summary = initial_validator.errors_translator(:summary_conformance_rules)
          end
        end

        def end_date_existing_footnote!
          unless original_footnote.already_end_dated?
            original_footnote.validity_end_date = validity_start_date

            ::WorkbasketValueObjects::Shared::SystemOpsAssigner.new(
              original_footnote, system_ops.merge(operation: "U")
            ).assign!(false)

            original_footnote.save
          end
        end

        def end_date_existing_footnote_description_period!
          footnote_description_period = original_footnote.footnote_description
                                                         .footnote_description_period

          unless footnote_description_period.already_end_dated?
            footnote_description_period.validity_end_date = (description_validity_start_date || validity_start_date)

            ::WorkbasketValueObjects::Shared::SystemOpsAssigner.new(
              footnote_description_period, system_ops.merge(operation: "U")
            ).assign!(false)

            footnote_description_period.save
          end
        end

        def add_footnote!
          @footnote = Footnote.new(
            validity_start_date: validity_start_date,
            validity_end_date: validity_end_date
          )

          footnote.footnote_type_id = original_footnote.footnote_type_id

          assign_system_ops!(footnote)
          set_primary_key!(footnote)

          footnote.save if persist_mode?
        end

        def add_footnote_description_period!
          @footnote_description_period = FootnoteDescriptionPeriod.new(
            validity_start_date: validity_start_date,
            validity_end_date: description_should_be_changed_later? ? description_validity_start_date : validity_end_date
          )

          footnote_description_period.footnote_id = footnote.footnote_id
          footnote_description_period.footnote_type_id = footnote.footnote_type_id

          assign_system_ops!(footnote_description_period)
          set_primary_key!(footnote_description_period)

          footnote_description_period.save if persist_mode?
        end

        def add_footnote_description!
          @footnote_description = FootnoteDescription.new(
            description: description_should_be_changed_later? ? original_footnote.description : description,
            language_id: "EN"
          )

          footnote_description.footnote_id = footnote.footnote_id
          footnote_description.footnote_type_id = footnote.footnote_type_id
          footnote_description.footnote_description_period_sid = footnote_description_period.footnote_description_period_sid

          assign_system_ops!(footnote_description)
          set_primary_key!(footnote_description)

          footnote_description.save if persist_mode?
        end

        def add_next_footnote_description_period!
          @next_footnote_description_period = FootnoteDescriptionPeriod.new(
            validity_start_date: description_validity_start_date,
            validity_end_date: validity_end_date
          )

          next_footnote_description_period.footnote_id = (footnote || original_footnote).footnote_id
          next_footnote_description_period.footnote_type_id = (footnote || original_footnote).footnote_type_id

          assign_system_ops!(next_footnote_description_period)
          set_primary_key!(next_footnote_description_period)

          next_footnote_description_period.save if persist_mode?
        end

        def add_next_footnote_description!
          @next_footnote_description = FootnoteDescription.new(
            description: description,
            language_id: "EN"
          )

          next_footnote_description.footnote_id = (footnote || original_footnote).footnote_id
          next_footnote_description.footnote_type_id = (footnote || original_footnote).footnote_type_id
          next_footnote_description.footnote_description_period_sid = next_footnote_description_period.footnote_description_period_sid

          assign_system_ops!(next_footnote_description)
          set_primary_key!(next_footnote_description)

          next_footnote_description.save if persist_mode?
        end

        def description_changed?
          original_footnote.description.to_s.squish != description.to_s.squish
        end

        def description_should_be_changed_later?
          description_changed? &&
          description_validity_start_date.present? &&
          description_validity_start_date != validity_start_date
        end

        def it_is_just_description_changed?
          @it_is_just_description_changed ||= (
            description_changed? &&
            original_footnote.validity_start_date.strftime("%Y-%m-%d") == validity_start_date.try(:strftime, "%Y-%m-%d") &&
            original_footnote.validity_end_date.try(:strftime, "%Y-%m-%d") == validity_end_date.try(:strftime, "%Y-%m-%d") &&
            original_footnote.commodity_codes == commodity_codes &&
            original_footnote.measure_sids == measure_sids
          )
        end

        def end_date_existing_commodity_codes_associations!
          original_footnote.footnote_association_goods_nomenclatures.map do |item|
            unless item.already_end_dated?
              ::WorkbasketValueObjects::Shared::SystemOpsAssigner.new(
                item, system_ops.merge(operation: "D")
              ).assign!(false)

              item.save
            end
          end
        end

        def add_new_commodity_codes_associations!
          commodity_codes.map do |code|
            gn = GoodsNomenclature.actual
                                  .by_code(code)
                                  .first

            if gn.present?
              association = FootnoteAssociationGoodsNomenclature.new(
                validity_start_date: validity_start_date,
                validity_end_date: validity_end_date
              )

              association.goods_nomenclature_sid = gn.goods_nomenclature_sid
              association.goods_nomenclature_item_id = gn.goods_nomenclature_item_id
              association.productline_suffix = gn.producline_suffix

              association.footnote_type = footnote.footnote_type_id
              association.footnote_id = footnote.footnote_id

              assign_system_ops!(association)
              association.save if persist_mode?

              @commodity_codes_candidates << association
            end
          end
        end

        def add_new_measures_associations!
          measure_sids.map do |measure_sid|
            measure = Measure.by_measure_sid(measure_sid)
                             .first

            if measure.present?
              association = FootnoteAssociationMeasure.new()
              association.measure_sid = measure.measure_sid

              association.footnote_type_id = footnote.footnote_type_id
              association.footnote_id = footnote.footnote_id

              assign_system_ops!(association)
              association.save if persist_mode?

              @measures_candidates << association
            end
          end
        end

        def persist_mode?
          @persist.present?
        end

        def setup_attrs_parser!
          @attrs_parser = ::WorkbasketValueObjects::EditFootnote::AttributesParser.new(
            settings_params
          )
        end

        def get_conformance_errors(record)
          res = {}

          record.conformance_errors.map do |k, v|
            message = if v.is_a?(Array)
              v.flatten.join(' ')
            else
              v
            end

            res[k.to_s] = "<strong class='workbasket-conformance-error-code'>#{k.to_s}</strong>: #{message}".html_safe
          end

          res
        end

        def validator_class(record)
          "#{record.class.name}Validator".constantize
        end
    end
  end
end
