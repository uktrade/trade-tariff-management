require "rails_helper"

describe "Saving of Prorogation regulation" do
  include_context "regulation_saver_base_context"

  let(:regulation_role) { "5" }
  let(:regulation_class) { ProrogationRegulation }

  let(:ops) do
    base_ops.merge(
      role: regulation_role,
      published_date: date_to_s(validity_start_date)
    )
  end
end
