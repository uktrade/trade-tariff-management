module Measures
  class BulkSaver

    include ::CustomLogger

    VALIDATING_OPS = [
      "validity_start_date",
      "validity_end_date",
      "goods_nomenclature",
      "regulation",
      "measure_type",
      "additional_code",
      "geographical_area",
      "footnotes",
      "measure_components",
      "measure_conditions",
      "excluded_geographical_areas"
    ]

    attr_accessor :current_admin,
                  :collection_ops,
                  :workbasket,
                  :errored_ids

    def initialize(current_admin, workbasket, collection_ops=[])
      @errored_ids = []

      @current_admin = current_admin
      @workbasket = workbasket
      @collection_ops = collection_ops.map do |item_ops|
        ActiveSupport::HashWithIndifferentAccess.new(item_ops)
      end

      log_it("collection_ops: #{@collection_ops.inspect}")
    end

    # def valid?
    #   collection_ops.map do |item_ops|

    #     Rails.logger.info ""
    #     Rails.logger.info "-" * 100
    #     Rails.logger.info ""
    #     Rails.logger.info "item_ops: #{item_ops.keys}"
    #     Rails.logger.info ""
    #     Rails.logger.info "-" * 100
    #     Rails.logger.info ""

    #     item = workbasket.get_item_by_id(
    #       item_ops[:measure_sid].to_s
    #     )

    #     item.new_data = item_ops.to_json
    #     item.save
    #   end

    #   false
    # end

    def valid?
      validate_collection!
      no_errors?
    end

    def persist!
      Rails.logger.info ""
      Rails.logger.info "-" * 100
      Rails.logger.info ""
      Rails.logger.info "PERSIST OF MEASURES!"
      Rails.logger.info ""
      Rails.logger.info "-" * 100
      Rails.logger.info ""

      collection_ops.map do |item_ops|
        if item_ops[:errors_details].blank?
          Rails.logger.info ""
          Rails.logger.info "-" * 100
          Rails.logger.info ""
          Rails.logger.info "  [#{item_ops[:measure_sid]}] saving!"
          Rails.logger.info ""
          Rails.logger.info "-" * 100
          Rails.logger.info ""

          item = workbasket.items.where(
            record_id: item_ops[:measure_sid],
            record_type: "Measure"
          ).first

          item.new_data = item_ops.to_json
          item.save
        end
      end
    end

    def collection_overview_summary
      {
        number_of_updated_measures: collection_ops.count,
        success: :ok
      }
    end

    def errors_overview
      errored_ids
    end

    private

      def validate_collection!
        Rails.logger.info ""
        Rails.logger.info "-" * 100
        Rails.logger.info ""
        Rails.logger.info " VALIDATE COLLECTION STARTED"
        Rails.logger.info ""
        Rails.logger.info "-" * 100
        Rails.logger.info ""

        collection_ops.each_with_index do |measure_params, index|
          Rails.logger.info ""
          Rails.logger.info "-" * 100
          Rails.logger.info ""
          Rails.logger.info "  [#{index} | #{measure_params[:measure_sid]}]"
          Rails.logger.info ""
          Rails.logger.info "-" * 100
          Rails.logger.info ""

          errors = validate_measure!(measure_params)

          Rails.logger.info ""
          Rails.logger.info "-" * 100
          Rails.logger.info ""
          Rails.logger.info "  [#{index} | #{measure_params[:measure_sid]}] #{errors.inspect}"
          Rails.logger.info ""
          Rails.logger.info "-" * 100
          Rails.logger.info ""

          if errors.present?
            @collection_ops[index] = measure_params.merge(errors_details: errors)
            @errored_ids << measure_params[:measure_sid]
          end
        end
      end

      def validate_measure!(measure_params={})
        errors = {}

        Rails.logger.info ""
        Rails.logger.info "-" * 100
        Rails.logger.info ""
        Rails.logger.info " VALIDATING of measure_params #{measure_params.inspect}"
        Rails.logger.info ""
        Rails.logger.info "-" * 100
        Rails.logger.info ""

        measure = Measure.new(
          prepare_measure_ops(measure_params)
        )
        measure.measure_sid = Measure.max(:measure_sid).to_i + 1

        Rails.logger.info ""
        Rails.logger.info "-" * 100
        Rails.logger.info ""
        Rails.logger.info " Ops prepared, trying to validate #{measure.inspect}"
        Rails.logger.info ""
        Rails.logger.info "-" * 100
        Rails.logger.info ""

        base_validator = MeasureValidator.new.validate(measure)

        if measure.conformance_errors.present?
          measure.conformance_errors.map do |error_code, error_details_list|
            errors[get_error_area(base_validator, error_code)] = error_details_list
          end
        end

        errors
      end

      def prepare_measure_ops(ops)
        res = {}

        res[:start_date] = ops["validity_start_date"].to_date
        res[:end_date] = ops["validity_end_date"].try(:to_date) if ops["validity_end_date"] != "-"

        if ops["goods_nomenclature"].present?
          res[:goods_nomenclature_code] = ops["goods_nomenclature"]["goods_nomenclature_item_id"]
        end

        if ops["additional_code"].present?
          res[:additional_code] = ops["additional_code"]["additional_code"]
          res[:additional_code_type_id] = ops["additional_code"]["type_id"]
        end

        if ops["measure_type"].present?
          res[:measure_type_id] = ops["measure_type"]["measure_type_id"]
        end

        if ops["regulation"].present?
          res[:regulation_id] = if ops["regulation"]["base_regulation_id"].present?
            ops["regulation"]["base_regulation_id"]
          elsif ops["regulation"]["modification_regulation_id"].present?
            ops["regulation"]["modification_regulation_id"]
          end
        end

        if ops["geographical_area"].present?
          res[:geographical_area_id] = ops["geographical_area"]["geographical_area_id"]
        end

        Rails.logger.info ""
        Rails.logger.info "-" * 100
        Rails.logger.info ""
        Rails.logger.info " res before normalizer: #{res.inspect}"
        Rails.logger.info ""
        Rails.logger.info "-" * 100
        Rails.logger.info ""

        res = ::Measures::AttributesNormalizer.new(res).normalized_params

        Rails.logger.info ""
        Rails.logger.info "-" * 100
        Rails.logger.info ""
        Rails.logger.info " res after normalizer: #{res.inspect}"
        Rails.logger.info ""
        Rails.logger.info "-" * 100
        Rails.logger.info ""

        res
      end

      def no_errors?
        errored_ids.blank?
      end

      def get_error_area(base_validator, error_code)
        base_validator.detect do |v|
          v.identifiers == error_code
        end.validation_options[:of]
      end
  end
end
