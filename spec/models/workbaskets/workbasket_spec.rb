require 'rails_helper'

describe Workbaskets::Workbasket do
  describe "can_withdraw?" do
    valid_states = described_class::APPROVER_SCOPE | described_class::STATES_WITH_ERROR
    invalid_states = described_class::STATUS_LIST.reject {|status| status.in?(valid_states) }

    valid_states.each do |state|
      context "when in #{state} state" do
        it "returns true" do
          subject.status = state
          expect(subject.can_withdraw?).to be true
        end
      end
    end

    invalid_states.each do |state|
      context "when in #{state} state" do
        it "returns false" do
          subject.status = state
          expect(subject.can_withdraw?).to be false
        end
      end
    end
  end
end
