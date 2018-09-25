module WorkbasketValueObjects
  module CreateRegulation
    class AttributesParser < WorkbasketValueObjects::AttributesParserBase

      SIMPLE_OPS = %w(
        operation_date
        role
        base_regulation_id
        related_antidumping_regulation_id
        prefix
        publication_year
        regulation_number
        number_suffix
        replacement_indicator
        information_text
        effective_end_date
        regulation_group_id
        published_date
        abrogation_date
      )

      SIMPLE_OPS.map do |option_name|
        define_method(option_name) do
          ops[option_name]
        end
      end

      ALIASES = {
          role: :method_regulation_role,
          effective_end_date: :method_effective_end_date,
      }

      attr_accessor :ops,
                    :normalized_params,
                    :target_class

      def initialize(workbasket_settings, step, ops = nil)
        @workbasket_settings = workbasket_settings
        @step = step
        @ops = if ops.present?
                 ops
               else
                 ActiveSupport::HashWithIndifferentAccess.new(
                     workbasket_settings.settings
                 )
               end

        @ops = @ops.select do |k, v|
          v.present?
        end

        @normalized_params = {}
        @ops.map do |k, v|
          if ALIASES.keys.include?(k.to_sym)
            if ALIASES[k.to_sym].to_s.starts_with?("method_")
              @normalized_params.merge!(
                  send(ALIASES[k.to_sym], @ops[k])
              )
            else
              @normalized_params[ALIASES[k.to_sym]] = v
            end
          else
            @normalized_params[k] = v
          end
        end

        stub_some_attributes
        @normalized_params = ActiveSupport::HashWithIndifferentAccess.new(normalized_params)

      end

      def stub_some_attributes
        @normalized_params[:officialjournal_number] = '00'
        @normalized_params[:officialjournal_page] = 1

        @normalized_params[:community_code] = 1 if target_class == BaseRegulation
      end

      def fetch_regulation_number
        base = "#{prefix}#{publication_year}#{regulation_number}"
        base += number_suffix.to_s
        base.delete(' ')
      end

      def workbasket_name
        fetch_regulation_number
      end

      def method_regulation_role(role)
        ops = {}

        @target_class = case role
                          when "1", "2", "3"
                            BaseRegulation
                          when "4"
                            ModificationRegulation
                          when "5"
                            ProrogationRegulation
                          when "6"
                            CompleteAbrogationRegulation
                          when "7"
                            ExplicitAbrogationRegulation
                          when "8"
                            FullTemporaryStopRegulation
                        end

        ops[target_class.primary_key[1]] = role
        ops[target_class.primary_key[0]] = fetch_regulation_number

        ops
      end

      def method_effective_end_date(effective_end_date)
        ops = {}

        if role == "8"
          ops[:effective_enddate] = effective_end_date
        else
          ops[:effective_end_date] = effective_end_date
        end

        ops
      end

      def effective_end_date_formatted
        date_to_format(effective_end_date)
      end

      def published_date_formatted
        date_to_format(published_date)
      end

      def abrogation_date_formatted
        date_to_format(abrogation_date)
      end

    end
  end
end
