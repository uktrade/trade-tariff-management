require 'rails_helper'

RSpec.describe(Workbaskets::Workbasket) do
  describe "#can_withdraw?" do
    valid_states = described_class::APPROVER_SCOPE | described_class::STATES_WITH_ERROR
    invalid_states = described_class::STATUS_LIST.reject { |status| status.in?(valid_states) }

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

  describe "#first_operation_date" do
    context "where there are no saved workbaskets" do
      it "returns nil" do
        expect(described_class.first_operation_date).to be nil
      end
    end

    context "where there are saved workbaskets" do
      before do
        create(:workbasket, operation_date: operation_date)
        create(:workbasket, operation_date: current_date)
      end

      let(:current_date) { Date.today }

      context "where the oldest workbasket has no operation date" do
        let(:operation_date) { nil }

        it "returns the next oldest workbasket's operation date" do
          expect(described_class.first_operation_date).to eq current_date
        end
      end

      context "where the oldest workbasket has an operation date" do
        let(:operation_date) { Date.today - 7.days }

        it "returns that operation date" do
          expect(described_class.first_operation_date).to eq operation_date
        end
      end
    end
  end
end
