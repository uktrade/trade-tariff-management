module Measures
  module SharedMethods
    module Date

      private

        def is_clause
          "#{field_name}::date = ?"
        end

        def is_not_clause
          "#{field_name} IS NULL OR #{field_name}::date != ?"
        end

        def is_before_clause
          "#{field_name}::date < ?"
        end

        def is_before_or_nil_clause
          "#{field_name}::date < ? OR #{field_name} IS NULL"
        end

        def is_after_clause
          "#{field_name}::date > ?"
        end

        def is_after_or_nil_clause
          "#{field_name}::date > ? OR #{field_name} IS NULL"
        end
    end
  end
end
