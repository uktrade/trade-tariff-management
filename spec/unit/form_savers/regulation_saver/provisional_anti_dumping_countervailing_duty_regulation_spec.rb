require "rails_helper"

describe "Saving of Provisional anti-dumping/countervailing duty" do

  include_context "regulation_saver_base_context"

  let(:regulation_role) { "2" }
  let(:regulation_class) { BaseRegulation }

  let!(:base_regulation) do
    create(:base_regulation,
      base_regulation_role: "1",
      base_regulation_id: "D9402622"
    )
  end

  let(:ops) do
    base_ops.merge(
      role: regulation_role,
      validity_start_date: date_to_s(validity_start_date),
      validity_end_date: date_to_s(validity_end_date),
      effective_end_date: date_to_s(effective_end_date),
      regulation_group_id: regulation_group.regulation_group_id,
      antidumping_regulation_role: base_regulation.base_regulation_role,
      related_antidumping_regulation_id: base_regulation.base_regulation_id
    )
  end
end
