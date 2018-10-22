module AdditionalCodes
  class BulkSaver

    attr_accessor :current_admin,
                  :collection_ops,
                  :errors_collection,
                  :workbasket,
                  :workbasket_settings

    def initialize(current_admin, workbasket, collection_ops=[])
      @errors_collection = {}
      @current_admin = current_admin
      @workbasket = workbasket
      @workbasket_settings = workbasket.settings

      @collection_ops = collection_ops.map do |item_ops|
        ActiveSupport::HashWithIndifferentAccess.new(item_ops)
      end
    end

    def valid?
      validate_collection!
      no_errors?
    end

    def persist!
      workbasket.clean_up_related_cache!

      workbasket.items.map do |item|
        item.persist!
      end

      workbasket.move_status_to!(current_admin, :awaiting_cross_check)
      #
      # Temporary decision (until we finish check / approve flow):
      #
      #  Submitting a workbasket would auto approve the workbasket (for now)
      #
      workbasket.move_status_to!(current_admin, :ready_for_export)
    end

    def success_response
      {
        number_of_updated_additional_codes: collection_ops.count,
        collection_sids: collection_sids,
        success: :ok
      }
    end

    def error_response
      {
        additional_codes_with_errors: errors_collection,
      }
    end

    private

      def validate_collection!
        collection_ops.each_with_index do |additional_code_params, index|
          item = workbasket_settings.get_item_by_id(
            additional_code_params[:additional_code_sid].to_s
          )
          item.new_data = additional_code_params.to_json
          item.row_id = additional_code_params[:row_id].to_s

          if item.deleted?
            item.validation_errors = [].to_json

          else
            errors = item.validate!(additional_code_params)

            if errors.present?
              @errors_collection[
                additional_code_params[:row_id].to_s
              ] = ['additional_code_sid']
              item.validation_errors = errors.to_json
            end
          end

          item.save
        end
      end

      def collection_sids
        collection_ops.map do |i|
          i['additional_code_sid'].to_s
        end
      end

      def no_errors?
        errors_collection.blank?
      end
  end
end
