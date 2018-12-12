require 'rails_helper'

describe "Regulation Form APIs: Regulations", type: :request do
  include_context "form_apis_base_context"
  include_context "form_apis_regulations_base_context"

  let(:target_url) do
    "/regulation_form_api/base_regulations.json"
  end

  private

  def information_text(regulation)
    "#{regulation.information_text} (#{regulation.validity_start_date.strftime('%d/%m/%Y')})"
  end
end
