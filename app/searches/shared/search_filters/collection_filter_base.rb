module Shared
  module SearchFilters
    class CollectionFilterBase
      def filtered_collection_params(list)
        list.map(&:strip)
            .select(&:present?).uniq
      end

      def filtered_hash_collection_params(list)
        # p ""
        # p "-" * 100
        # p ""
        # p " list: #{list.inspect}"
        # p ""
        # p "-" * 100
        # p ""

        res = list.reject do |v|
          # p ""
          # p "-" * 100
          # p ""
          # p "    v: #{v.inspect}"
          # p ""
          # p "-" * 100
          # p ""

          v.keys.first == "null"
        end

        # p ""
        # p "-" * 100
        # p ""
        # p " res: #{res.inspect}"
        # p ""
        # p "-" * 100
        # p ""

        res
      end
    end
  end
end
