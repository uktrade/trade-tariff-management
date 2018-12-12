require "rails_helper"

describe "Saving of Explicit abrogation regulation" do
  include_context "regulation_saver_base_context"
  include_context "abrogation_general_regulation_context"

  let(:regulation_role) { "7" }
  let(:regulation_class) { ExplicitAbrogationRegulation }
  let(:primary_key_prefix) { "explicit_abrogation_regulation" }

  let(:ops) do
    base_ops.merge(
      role: regulation_role,
      base_regulation_id: base_regulation.base_regulation_id,
      base_regulation_role: base_regulation.base_regulation_role,
      published_date: date_to_s(validity_start_date),
      abrogation_date: date_to_s(validity_start_date)
    )
  end
end
