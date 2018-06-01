module Measures
  module SearchFilters
    class CollectionFilterBase

      def filtered_collection_params(list)
        list.map(&:strip)
            .select do |item|
          item.present?
        end.uniq
      end
    end
  end
end
