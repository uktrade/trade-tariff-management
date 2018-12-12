require 'rails_helper'

describe "Measure Form APIs: Regulations", type: :request do
  include_context "form_apis_base_context"
  include_context "form_apis_regulations_base_context"

  let(:target_url) do
    "/regulations.json"
  end

  private

  def information_text(regulation)
    code = regulation.public_send(regulation.primary_key[0])
    "#{code}: #{regulation.information_text} (#{regulation.validity_start_date.strftime('%d/%m/%Y')})"
  end
end
