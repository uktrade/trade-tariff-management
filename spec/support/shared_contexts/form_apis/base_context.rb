require 'rails_helper'

shared_context "form_apis_regulation_base_context" do
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
end
