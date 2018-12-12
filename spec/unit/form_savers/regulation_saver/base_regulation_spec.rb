require "rails_helper"

describe "Saving of Base regulation" do
  include_context "regulation_saver_base_context"

  let(:regulation_role) { "1" }
  let(:regulation_class) { BaseRegulation }

  let(:ops) do
    base_ops.merge(
      role: regulation_role,
      validity_start_date: date_to_s(validity_start_date),
      validity_end_date: date_to_s(validity_end_date),
      effective_end_date: date_to_s(effective_end_date),
      regulation_group_id: regulation_group.regulation_group_id
    )
  end
end
