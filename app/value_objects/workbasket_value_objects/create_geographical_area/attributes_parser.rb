module WorkbasketValueObjects
  module CreateGeographicalArea
    class AttributesParser < WorkbasketValueObjects::AttributesParserBase

      SIMPLE_OPS = %w(
        geographical_code
        geographical_area_id
        description
        parent_geographical_area_group_id
        start_date
        end_date
        operation_date
      )

      SIMPLE_OPS.map do |option_name|
        define_method(option_name) do
          ops[option_name]
        end
      end

      private

        def prepare_ops
          # do nothing
        end
    end
  end
end
