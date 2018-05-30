require "rails_helper"

describe "Measure search: valid_from filter" do

  include_context "measures_search_base_context"
  include_context "measures_date_universal_context"

  let(:search_key) { "valid_from" }
  let(:field_name) { "validity_start_date" }
end
