module BulkEditHelpers
  module OrderByIdsQuery
    extend ActiveSupport::Concern

    included do
      dataset_module do
        def by_ids(key, collection_ids)
          where(key.to_sym => collection_ids)
        end

        def order_by_ids(key, ids)
          res = []

          ids.each_with_index.map do |id, index|
            res << [
              { key.to_sym => id }, index
            ]
          end

          order(Sequel.case(res, nil))
        end

        def bulk_edit_scope(key, measure_sids)
          by_ids(key, measure_sids).order_by_ids(key, measure_sids)
        end
      end
    end
  end
end
