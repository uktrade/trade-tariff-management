require "rails_helper"

describe "Saving of Full Temporary Stop regulation" do
  include_context "regulation_saver_base_context"

  let(:regulation_role) { "8" }
  let(:regulation_class) { FullTemporaryStopRegulation }

  let(:ops) do
    base_ops.merge(
      role: regulation_role,
      validity_start_date: date_to_s(validity_start_date),
      validity_end_date: date_to_s(validity_end_date),
      effective_end_date: date_to_s(effective_end_date),
      published_date: date_to_s(validity_start_date)
    )
  end
end
