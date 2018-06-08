require 'rails_helper'

describe BaseRegulation do
  describe 'validations' do
    # ROIMB1
    it { should validate_uniqueness.of([:base_regulation_id, :base_regulation_role])}
    # ROIMB3
    it { should validate_validity_dates }

    context "ROIMB4" do
      let(:base_regulation) {
        build(:base_regulation, regulation_group_id: regulation_group_id)
      }

      before { base_regulation.conformant? }

      describe "valid" do
        let(:regulation_group_id) { create(:regulation_group).regulation_group_id }
        it { expect(base_regulation.conformance_errors).to be_empty }
      end

      describe "invalid" do
        let(:regulation_group_id) { "ACC" }
        it {
          expect(base_regulation.conformance_errors).to have_key(:ROIMB4)
        }
      end
    end

    context "ROIMB5" do
      describe "allows specific fields to be modified" do
        it "valid" do
          base_regulation = create(
            :base_regulation,
            officialjournal_page: 11
          )
          modification_regulation = create(
            :modification_regulation,
            base_regulation_id: base_regulation.base_regulation_id,
            base_regulation_role: base_regulation.base_regulation_role
          )
          base_regulation.officialjournal_page = 12
          expect(
            base_regulation.conformant_for?(:update)
          ).to be_truthy
        end

        it "invalid" do
          base_regulation = create :base_regulation,
                                   information_text: "AB"
          modification_regulation = create(
            :modification_regulation,
            base_regulation_id: base_regulation.base_regulation_id,
            base_regulation_role: base_regulation.base_regulation_role
          )
          base_regulation.information_text = "AC"
          expect(
            base_regulation.conformant_for?(:update)
          ).to be_falsey
          expect(base_regulation.conformance_errors).to have_key(:ROIMB5)
        end
      end
    end

    context "ROIMB6" do
      describe "allow certain fields to be modified when regulation is abrogated" do
        it "valid" do
          base_regulation = create :base_regulation,
                                   :abrogated,
                                   officialjournal_page: 11
          base_regulation.officialjournal_page = 12
          expect(
            base_regulation.conformant_for?(:update)
          ).to be_truthy
        end

        it "invalid" do
          base_regulation = create :base_regulation,
                                   :abrogated,
                                   information_text: "AB"
          base_regulation.information_text = "AC"
          expect(
            base_regulation.conformant_for?(:update)
          ).to be_falsey
          expect(base_regulation.conformance_errors).to have_key(:ROIMB6)
        end
      end
    end

    context "ROIMB48" do
      it "valid" do
        base_regulation = create :base_regulation,
                                 effective_end_date: Date.today + 10.days
        base_regulation.validity_end_date = Date.today + 5.days
        expect(
          base_regulation.conformant_for?(:create)
        ).to be_truthy
      end

      it "invalid" do
        base_regulation = create :base_regulation,
                                 effective_end_date: Date.today + 10.days
        base_regulation.validity_end_date = Date.today + 15.days
        expect(
          base_regulation.conformant_for?(:create)
        ).to be_falsey
        expect(base_regulation.conformance_errors).to have_key(:ROIMB48)
      end
    end

    context "ROIMB44" do
      it "valid" do
        base_regulation = create :base_regulation,
                                 base_regulation_id: "C123",
                                 approved_flag: false
        base_regulation.approved_flag = true
        expect(base_regulation).to be_conformant
      end

      it "invalid" do
        base_regulation = create :base_regulation,
                                 base_regulation_id: "C123",
                                 approved_flag: true
        base_regulation.approved_flag = false
        expect(base_regulation).to_not be_conformant
        expect(base_regulation.conformance_errors).to have_key(:ROIMB44)
      end

      it "approved_flag" do
        base_regulation = create :base_regulation,
                                 base_regulation_id: "A123"
        base_regulation.approved_flag = true
        expect(base_regulation).to be_conformant
      end
    end

    context "ROIMB47" do
      it "valid" do
        regulation_group = create :regulation_group,
                                  validity_start_date: Date.today - 11.days
        base_regulation = create :base_regulation,
                                 regulation_group_id: regulation_group.regulation_group_id,
                                 validity_start_date: Date.today - 10.days
        expect(
          base_regulation.conformant_for?(:update)
        ).to be_truthy
      end

      it "invalid" do
        regulation_group = create :regulation_group,
                                  validity_start_date: Date.today - 11.days,
                                  validity_end_date: Date.today + 5.days
        base_regulation = create :base_regulation,
                                 regulation_group_id: regulation_group.regulation_group_id,
                                 validity_start_date: Date.today - 10.days,
                                 validity_end_date: Date.today + 10.days
        expect(
          base_regulation.conformant_for?(:update)
        ).to be_falsey
        expect(base_regulation.conformance_errors).to have_key(:ROIMB47)
      end
    end

    context "ROIMB8" do
      it "valid" do
        measure = create :measure,
                         :national,
                         validity_start_date: Date.today - 10.days
        base_regulation = create :base_regulation,
                                 base_regulation_id: measure.measure_generating_regulation_id,
                                 base_regulation_role: measure.measure_generating_regulation_role,
                                 validity_start_date: Date.today - 11.days
        expect(base_regulation).to be_conformant
      end

      it "invalid" do
        measure = create :measure,
                         :national,
                         validity_start_date: Date.today - 10.days,
                         validity_end_date: Date.today + 10.days
        base_regulation = create :base_regulation,
                                 base_regulation_id: measure.measure_generating_regulation_id,
                                 base_regulation_role: measure.measure_generating_regulation_role,
                                 validity_start_date: Date.today - 11.days,
                                 validity_end_date: Date.today + 5.days
        expect(base_regulation).to_not be_conformant
        expect(base_regulation.conformance_errors).to have_key(:ROIMB8)
      end
    end

    context "ROIMB11" do
      it "valid" do
        mpt_stop = create :measure_partial_temporary_stop,
                          validity_start_date: Date.today - 5.days
        measure = create :measure,
                         measure_generating_regulation_id: mpt_stop.partial_temporary_stop_regulation_id,
                         validity_start_date: Date.today - 5.days
        base_regulation = create :base_regulation,
                                 base_regulation_id: measure.measure_generating_regulation_id,
                                 base_regulation_role: measure.measure_generating_regulation_role,
                                 validity_start_date: Date.today - 10.days
        expect(base_regulation).to be_conformant
      end

      it "invalid" do
        mpt_stop = create :measure_partial_temporary_stop,
                          validity_start_date: Date.today - 10.days
        measure = create :measure,
                         measure_generating_regulation_id: mpt_stop.partial_temporary_stop_regulation_id,
                         validity_start_date: Date.today - 5.days
        base_regulation = create :base_regulation,
                                 base_regulation_id: measure.measure_generating_regulation_id,
                                 base_regulation_role: measure.measure_generating_regulation_role,
                                 validity_start_date: Date.today - 5.days
        expect(base_regulation).to_not be_conformant
        expect(base_regulation.conformance_errors).to have_key(:ROIMB11)
      end
    end

    context "ROIMB15" do
      it "valid" do
        base_regulation = create :base_regulation,
                                 validity_start_date: Date.today - 10.days
        modification_regulation = create :modification_regulation,
                                         base_regulation_id: base_regulation.base_regulation_id,
                                         base_regulation_role: base_regulation.base_regulation_role,
                                         validity_start_date: Date.today - 5.days
        expect(base_regulation).to be_conformant
      end

      it "invalid" do
        base_regulation = create :base_regulation,
                                 validity_start_date: Date.today - 5.days
        modification_regulation = create :modification_regulation,
                                         base_regulation_id: base_regulation.base_regulation_id,
                                         base_regulation_role: base_regulation.base_regulation_role,
                                         validity_start_date: Date.today - 10.days
        expect(base_regulation).to_not be_conformant
        expect(base_regulation.conformance_errors).to have_key(:ROIMB15)
      end
    end

    context "ROIMB19" do
      it "valid" do
        base_regulation = create :base_regulation,
                                 validity_start_date: Date.today - 10.days
        modification_regulation = create :modification_regulation,
                                         base_regulation_id: base_regulation.base_regulation_id,
                                         base_regulation_role: base_regulation.base_regulation_role,
                                         validity_start_date: Date.today - 10.days
        fts_regulation = create :fts_regulation,
                                full_temporary_stop_regulation_id: modification_regulation.modification_regulation_id,
                                full_temporary_stop_regulation_role: modification_regulation.modification_regulation_role,
                                validity_start_date: Date.today - 5.days
        expect(base_regulation).to be_conformant
      end

      it "invalid" do
        base_regulation = create :base_regulation,
                                 validity_start_date: Date.today - 5.days
        modification_regulation = create :modification_regulation,
                                         base_regulation_id: base_regulation.base_regulation_id,
                                         base_regulation_role: base_regulation.base_regulation_role,
                                         validity_start_date: Date.today - 5.days
        fts_regulation = create :fts_regulation,
                                full_temporary_stop_regulation_id: modification_regulation.modification_regulation_id,
                                full_temporary_stop_regulation_role: modification_regulation.modification_regulation_role,
                                validity_start_date: Date.today - 10.days
        expect(base_regulation).to_not be_conformant
        expect(base_regulation.conformance_errors).to have_key(:ROIMB19)
      end
    end

    context "ROIMB20" do
      it "valid" do
        base_regulation = create :base_regulation,
                                 validity_start_date: Date.today - 10.days,
                                 validity_end_date: Date.today + 10.days
        modification_regulation = create :modification_regulation,
                                         base_regulation_id: base_regulation.base_regulation_id,
                                         base_regulation_role: base_regulation.base_regulation_role,
                                         validity_start_date: Date.today - 10.days,
                                         validity_end_date: Date.today + 10.days
        fts_regulation = create :fts_regulation,
                                full_temporary_stop_regulation_id: modification_regulation.modification_regulation_id,
                                full_temporary_stop_regulation_role: modification_regulation.modification_regulation_role,
                                validity_start_date: Date.today - 5.days,
                                validity_end_date: Date.today + 5.days
        expect(base_regulation).to be_conformant
      end

      it "invalid" do
        base_regulation = create :base_regulation,
                                 validity_start_date: Date.today - 10.days,
                                 validity_end_date: Date.today + 5.days
        modification_regulation = create :modification_regulation,
                                         base_regulation_id: base_regulation.base_regulation_id,
                                         base_regulation_role: base_regulation.base_regulation_role,
                                         validity_start_date: Date.today - 10.days,
                                         validity_end_date: Date.today + 5.days
        fts_regulation = create :fts_regulation,
                                full_temporary_stop_regulation_id: modification_regulation.modification_regulation_id,
                                full_temporary_stop_regulation_role: modification_regulation.modification_regulation_role,
                                validity_start_date: Date.today - 5.days,
                                validity_end_date: Date.today + 10.days
        expect(base_regulation).to_not be_conformant
        expect(base_regulation.conformance_errors).to have_key(:ROIMB20)
      end
    end

    context "ROIMB21" do
      it "valid" do
        base_regulation = create(
          :base_regulation,
          validity_start_date: Date.today - 10.days
        )
        modification_regulation = create(
          :modification_regulation,
          base_regulation_id: base_regulation.base_regulation_id,
          base_regulation_role: base_regulation.base_regulation_role,
          validity_start_date: Date.today - 10.days
        )
        fts_regulation = create(
          :fts_regulation,
          full_temporary_stop_regulation_id: modification_regulation.modification_regulation_id,
          full_temporary_stop_regulation_role: modification_regulation.modification_regulation_role,
          validity_start_date: Date.today - 5.days
        )
        abrogation_regulation = create(
          :explicit_abrogation_regulation,
          explicit_abrogation_regulation_id: fts_regulation.full_temporary_stop_regulation_id,
          explicit_abrogation_regulation_role: fts_regulation.full_temporary_stop_regulation_role,
          abrogation_date: Date.today - 5.days
        )
        expect(base_regulation).to be_conformant
      end

      it "invalid" do
        base_regulation = create(
          :base_regulation,
          validity_start_date: Date.today - 5.days
        )
        modification_regulation = create(
          :modification_regulation,
          base_regulation_id: base_regulation.base_regulation_id,
          base_regulation_role: base_regulation.base_regulation_role,
          validity_start_date: Date.today - 5.days
        )
        fts_regulation = create(
          :fts_regulation,
          full_temporary_stop_regulation_id: modification_regulation.modification_regulation_id,
          full_temporary_stop_regulation_role: modification_regulation.modification_regulation_role,
          validity_start_date: Date.today - 5.days
        )
        abrogation_regulation = create(
          :explicit_abrogation_regulation,
          explicit_abrogation_regulation_id: fts_regulation.full_temporary_stop_regulation_id,
          explicit_abrogation_regulation_role: fts_regulation.full_temporary_stop_regulation_role,
          abrogation_date: Date.today - 10.days
        )
        expect(base_regulation).to_not be_conformant
        expect(base_regulation.conformance_errors).to have_key(:ROIMB21)
      end
    end

    context "ROIMB22" do
      it "valid" do
        measure = create(
          :measure,
          :national,
          validity_start_date: Date.today - 10.days,
          validity_end_date: Date.today + 10.days
        )
        base_regulation = create(
          :base_regulation,
          base_regulation_id: measure.measure_generating_regulation_id,
          base_regulation_role: measure.measure_generating_regulation_role,
          validity_start_date: Date.today - 11.days,
          validity_end_date: Date.today + 11.days
        )
        expect(base_regulation).to be_conformant
      end

      it "invalid" do
        measure = create(
          :measure,
          :national,
          validity_start_date: Date.today - 10.days,
          validity_end_date: Date.today + 10.days
        )
        base_regulation = create(
          :base_regulation,
          base_regulation_id: measure.measure_generating_regulation_id,
          base_regulation_role: measure.measure_generating_regulation_role,
          validity_start_date: Date.today - 11.days,
          validity_end_date: Date.today + 11.days
        )
        base_regulation.validity_end_date = Date.today + 5.days
        expect(
          base_regulation.conformant_for?(:update)
        ).to be_falsey
        expect(base_regulation.conformance_errors).to have_key(:ROIMB22)
      end
    end
  end
end
