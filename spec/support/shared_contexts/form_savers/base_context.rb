require 'rails_helper'

shared_context "form_savers_base_context" do

  let(:user) do
    create(:user)
  end

  let(:validity_start_date) do
    1.day.from_now
  end

  let(:validity_end_date) do
    validity_start_date + 1.year
  end

  let(:operation_date) do
    validity_start_date
  end

  private

    def value_by_type(value)
      case value.class.name
      when "Time", "DateTime", "Date"
        date_to_s(value)
      else
        value
      end
    end

    def date_to_s(date)
      date.strftime("%d/%m/%Y")
    end
end
