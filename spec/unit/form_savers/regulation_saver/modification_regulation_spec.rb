require "rails_helper"

describe "Saving of Modification regulation" do
  include_context "regulation_saver_base_context"

  let(:regulation_role) { "4" }
  let(:regulation_class) { ModificationRegulation }

  let(:ops) do
    base_ops.merge(
      role: regulation_role,
      base_regulation_id: base_regulation.base_regulation_id,
      base_regulation_role: base_regulation.base_regulation_role,
      validity_start_date: date_to_s(validity_start_date),
      validity_end_date: date_to_s(validity_end_date),
      effective_end_date: date_to_s(effective_end_date)
    )
  end
end
