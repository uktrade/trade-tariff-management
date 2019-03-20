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

  describe '#can_continue_cross_check?' do
    it 'returns false if user is an approver_user' do
      user = create(:user, approver_user: true)
      workbasket = create(:workbasket, status: 'awaiting_cross_check' )
      expect(workbasket.can_continue_cross_check?(user)).to eq false
    end

    it 'returns false if user is the author of the workbasket' do
      user = create(:user)
      workbasket = create(:workbasket, status: 'awaiting_cross_check', user_id: user.id)
      expect(workbasket.can_continue_cross_check?(user)).to eq false
    end

    it 'returns false if workbasket is not awaiting cross-check' do
      user = create(:user)
      workbasket = create(:workbasket, status: 'published', user_id: user.id)
      expect(workbasket.can_continue_cross_check?(user)).to eq false
    end

    it 'returns true otherwise' do
      user = create(:user)
      workbasket = create(:workbasket, status: 'awaiting_cross_check')
      expect(workbasket.can_continue_cross_check?(user)).to eq true
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

  describe "#is_bulk_edit?" do
    it "returns true for a 'bulk_edit_of_measures' workbasket" do
      workbasket = build(:workbasket, type: :bulk_edit_of_measures)
      expect(workbasket.is_bulk_edit?).to eq true
    end

    it "returns false for a non bulk edit (e.g. 'create_measures') workbasket" do
      workbasket = build(:workbasket, type: :create_measures)
      expect(workbasket.is_bulk_edit?).to eq false
    end
  end
end
