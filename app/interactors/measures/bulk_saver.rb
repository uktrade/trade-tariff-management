module Measures
  class BulkSaver

    include ::CustomLogger

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

    def valid?
      collection_ops.map do |item_ops|

        Rails.logger.info ""
        Rails.logger.info "-" * 100
        Rails.logger.info ""
        Rails.logger.info "item_ops: #{item_ops.keys}"
        Rails.logger.info ""
        Rails.logger.info "-" * 100
        Rails.logger.info ""

        item = workbasket.get_item_by_id(
          item_ops[:measure_sid].to_s
        )

        item.new_data = item_ops.to_json
        item.save
      end

      false
    end

    # def valid?
    #   validate_collection!
    #   no_errors?
    # end

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

        measure = Measure.new(measure_params)
        measure.measure_sid = Measure.max(:measure_sid).to_i + 1

        base_validator = MeasureValidator.new.validate(measure)

        if measure.conformance_errors.present?
          measure.conformance_errors.map do |error_code, error_details_list|
            errors[get_error_area(base_validator, error_code)] = error_details_list
          end
        end

        errors
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
