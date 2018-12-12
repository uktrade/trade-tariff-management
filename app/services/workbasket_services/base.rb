module WorkbasketServices
  class Base
    DEFAULT_LANGUAGE = "EN".freeze

  private

    def geographical_area(area_id)
      GeographicalArea.actual
                      .by_id(area_id)
                      .first
    end

    def set_primary_key(record)
      ::WorkbasketValueObjects::Shared::PrimaryKeyGenerator.new(record).assign!
    end

    def set_system_data(record)
      saver_class.send(:assign_system_ops!, record)
      set_primary_key(record)
    end
  end
end
