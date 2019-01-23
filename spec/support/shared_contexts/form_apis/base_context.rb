require 'rails_helper'

shared_context "form_apis_base_context" do
  let!(:user) do
    create(:user)
  end

  let(:headers) do
    {
      "Content-type" => "application/json"
    }
  end

  private

  def collection
    JSON.parse(response.body)
  end

  def date_to_format(date_in_string)
    date_in_string.to_date
                  .strftime("%d/%m/%Y")
  end
end
