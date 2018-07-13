module Workbaskets
  class CreateMeasuresSettings < Sequel::Model(:create_measures_workbasket_settings)

    plugin :timestamps

    validates do
      presence_of :workbasket_id
    end

    def workbasket
      Workbaskets::Workbasket.find(id: workbasket_id)
    end
  end
end
