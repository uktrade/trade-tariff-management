require 'rails_helper'

describe GeographicalArea do
  describe 'associations' do
    describe 'geographical area description' do
      let!(:geographical_area)                { create :geographical_area }
      let!(:geographical_area_description1)   {
        create :geographical_area_description, :with_period,
                                                            geographical_area_sid: geographical_area.geographical_area_sid,
                                                            valid_at: 2.years.ago,
                                                            valid_to: nil
      }
      let!(:geographical_area_description2) {
        create :geographical_area_description, :with_period,
                                                            geographical_area_sid: geographical_area.geographical_area_sid,
                                                            valid_at: 5.years.ago,
                                                            valid_to: 3.years.ago
      }

      context 'direct loading' do
        it 'loads correct description respecting given actual time' do
          TimeMachine.now do
            expect(
              geographical_area.geographical_area_description.pk
            ).to eq geographical_area_description1.pk
          end
        end

        it 'loads correct description respecting given time' do
          TimeMachine.at(1.year.ago) do
            expect(
              geographical_area.geographical_area_description.pk
            ).to eq geographical_area_description1.pk
          end

          TimeMachine.at(4.years.ago) do
            expect(
              geographical_area.reload.geographical_area_description.pk
            ).to eq geographical_area_description2.pk
          end
        end
      end

      context 'eager loading' do
        it 'loads correct description respecting given actual time' do
          TimeMachine.now do
            expect(
              GeographicalArea.where(geographical_area_sid: geographical_area.geographical_area_sid)
                          .eager(:geographical_area_descriptions)
                          .first
                          .geographical_area_description.pk
            ).to eq geographical_area_description1.pk
          end
        end

        it 'loads correct description respecting given time' do
          TimeMachine.at(1.year.ago) do
            result = GeographicalArea.eager(:geographical_area_descriptions)
                      .where(geographical_area_sid: geographical_area.geographical_area_sid)
                      .first.geographical_area_description.pk
            expect(result).to eq(geographical_area_description1.pk)
          end
        end

        it 'loads correct description respecting given time' do
          TimeMachine.at(4.years.ago) do
            result = GeographicalArea.where(geographical_area_sid: geographical_area.geographical_area_sid)
                      .eager(:geographical_area_descriptions)
                      .first.geographical_area_description.pk
            expect(result).to eq(geographical_area_description2.pk)
          end
        end
      end
    end

    describe 'contained geographical areas' do
      let!(:geographical_area)                { create :geographical_area, geographical_area_id: 'xx' }
      let!(:contained_area_present)           {
        create :geographical_area, geographical_area_id: 'ab',
                                                                           validity_start_date: Date.today.ago(2.years),
                                                                           validity_end_date: Date.today.ago(2.years)
      }
      let!(:contained_area_past) {
        create :geographical_area, geographical_area_id: 'de',
                                                                           validity_start_date: Date.today.ago(5.years),
                                                                           validity_end_date: 3.years.ago
      }
      let!(:geographical_area_membership1) {
        create :geographical_area_membership, geographical_area_sid: contained_area_present.geographical_area_sid,
                                                                                      geographical_area_group_sid: geographical_area.geographical_area_sid,
                                                                                      validity_start_date: Date.today.ago(2.years),
                                                                                      validity_end_date: nil
      }
      let!(:geographical_area_membership2) {
        create :geographical_area_membership, geographical_area_sid: contained_area_past.geographical_area_sid,
                                                                                      geographical_area_group_sid: geographical_area.geographical_area_sid,
                                                                                      validity_start_date: Date.today.ago(5.years),
                                                                                      validity_end_date: 3.years.ago
      }

      context 'direct loading' do
        it 'loads correct description respecting given actual time' do
          TimeMachine.now do
            expect(
              geographical_area.contained_geographical_areas.map(&:pk)
            ).to include contained_area_present.pk
          end
        end

        it 'loads correct description respecting given time' do
          TimeMachine.at(1.year.ago) do
            expect(
              geographical_area.contained_geographical_areas.map(&:pk)
            ).to include contained_area_present.pk
          end

          TimeMachine.at(4.years.ago) do
            expect(
              geographical_area.reload.contained_geographical_areas.map(&:pk)
            ).to include contained_area_past.pk
          end
        end
      end

      context 'eager loading' do
        it 'loads correct description respecting given actual time' do
          TimeMachine.now do
            expect(
              GeographicalArea.where(geographical_area_sid: geographical_area.geographical_area_sid)
                          .eager(:contained_geographical_areas)
                          .all
                          .first
                          .contained_geographical_areas
                          .map(&:pk)
            ).to include contained_area_present.pk
          end
        end

        it 'loads correct description respecting given time' do
          TimeMachine.at(1.year.ago) do
            expect(
              GeographicalArea.where(geographical_area_sid: geographical_area.geographical_area_sid)
                          .eager(:contained_geographical_areas)
                          .all
                          .first
                          .contained_geographical_areas(reload: true)
                          .map(&:pk)
            ).to include contained_area_present.pk
          end

          TimeMachine.at(4.years.ago) do
            expect(
              GeographicalArea.where(geographical_area_sid: geographical_area.geographical_area_sid)
                          .eager(:contained_geographical_areas)
                          .all
                          .first
                          .contained_geographical_areas(reload: true)
                          .map(&:pk)
            ).to include contained_area_past.pk
          end
        end
      end
    end
  end

  describe 'validations' do
    # GA1 The combination geographical area id + validity start date must be unique.
    it { is_expected.to validate_uniqueness.of(%i[geographical_area_id validity_start_date]) }
    # GA2 The start date must be less than or equal to the end date.
    it { is_expected.to validate_validity_dates }

    describe "GA3" do
      it "without description record" do
        geographical_area = create :geographical_area
        geographical_area.geographical_area_sid = generate(:geographical_area_sid)
        expect(geographical_area).to_not be_conformant
        expect(geographical_area.conformance_errors).to have_key(:GA3)
      end

      it "start date of first description" do
        geographical_area = create :geographical_area,
                                   validity_start_date: Date.today - 10.days
        geographical_area_description = geographical_area.geographical_area_description
        geographical_area_description.geographical_area_description_period.validity_start_date = Date.today - 8.days
        expect(geographical_area).to_not be_conformant
        expect(geographical_area.conformance_errors).to have_key(:GA3)
      end

      it "two descriptions may not have the same start date" do
        validity_start_date = Date.today - 10.days
        geographical_area = create :geographical_area,
                                   validity_start_date: validity_start_date
        geographical_area_description2 = create(
          :geographical_area_description,
          :with_period,
          valid_at: validity_start_date,
          geographical_area_sid: geographical_area.geographical_area_sid
        )
        expect(geographical_area).to_not be_conformant
        expect(geographical_area.conformance_errors).to have_key(:GA3)
      end

      it "start date of the description must be less than or equal to the end date" do
        geographical_area = create :geographical_area,
                                   validity_end_date: Date.today + 5.days
        geographical_area_description = geographical_area.geographical_area_description
        geographical_area_description.geographical_area_description_period.validity_end_date = Date.today + 10.days
        expect(geographical_area).to_not be_conformant
        expect(geographical_area.conformance_errors).to have_key(:GA3)
      end

      it "valid description record" do
        geographical_area = create :geographical_area,
                                    validity_start_date: Date.current.ago(3.years),
                                    validity_end_date: Date.current + 10.days

        ga_description = geographical_area.geographical_area_description
        ga_description.geographical_area_description_period.validity_end_date = Date.current + 10.days
        expect(geographical_area).to be_conformant
      end
    end

    describe "GA4" do
      let(:geographical_area) {
        build(:geographical_area, parent_geographical_area_group_sid: parent_id)
      }

      before { geographical_area.conformant? }

      context "invalid parent id" do
        let(:parent_id) { "435" }

        it {
          expect(geographical_area.conformance_errors).to have_key(:GA4)
        }
      end

      context "invalid area code" do
        let(:parent_id) {
          create(:geographical_area, :country).geographical_area_sid
        }

        it {
          expect(geographical_area.conformance_errors).to have_key(:GA4)
        }
      end

      context "valid" do
        let(:parent_id) {
          create(:geographical_area, geographical_code: "1").geographical_area_sid
        }

        it {
          expect(geographical_area.conformance_errors).to_not have_key(:GA4)
        }
      end
    end

    describe "GA5" do
      let(:geographical_area) {
        create(:geographical_area,
              validity_end_date: Date.current,
              validity_start_date: 3.years.ago,
              parent_geographical_area: parent)
      }

      before { geographical_area.conformant? }

      context "invalid parent period" do
        context "start date" do
          let(:parent) {
            create(:geographical_area, validity_start_date: Date.yesterday)
          }

          it {
            expect(geographical_area.conformance_errors).to have_key(:GA5)
          }
        end

        context "end date" do
          let(:parent) {
            create(:geographical_area,
                   validity_end_date: Date.yesterday,
                   validity_start_date: 3.years.ago)
          }

          it {
            expect(geographical_area.conformance_errors).to have_key(:GA5)
          }
        end

        context "without end date" do
          let(:parent) {
            create(:geographical_area,
                                validity_end_date: Date.current,
                                validity_start_date: 3.years.ago)
          }

          before {
            geographical_area.validity_end_date = nil
            geographical_area.conformant?
          }

          it {
            expect(geographical_area.conformance_errors).to have_key(:GA5)
          }
        end

        context "with start_date after parent and no end date" do
          let(:parent) {
            create(:geographical_area,
                                validity_end_date: Date.current,
                                validity_start_date: 3.years.ago)
          }

          before {
            geographical_area.validity_start_date = Date.today.ago(2.years)
            geographical_area.validity_end_date = nil
            geographical_area.conformant?
          }

          it {
            expect(geographical_area.conformance_errors).to have_key(:GA5)
          }
        end
      end

      context "valid" do
        context "with end date" do
          let(:parent) {
            create(:geographical_area,
                   validity_end_date: Date.current,
                   validity_start_date: 3.years.ago)
          }

          it {
            expect(geographical_area.conformance_errors).to_not have_key(:GA5)
          }
        end

        context "parent without end date" do
          let(:parent) {
            create(:geographical_area,
                   validity_end_date: nil,
                   validity_start_date: 3.years.ago)
          }

          it {
            expect(geographical_area.conformance_errors).to_not have_key(:GA5)
          }
        end

        context "both without end dates" do
          let(:parent) {
            create(:geographical_area,
                   validity_end_date: nil,
                   validity_start_date: 3.years.ago)
          }

          before {
            geographical_area.validity_end_date = nil
            geographical_area.conformant?
          }

          it {
            expect(geographical_area.conformance_errors).to_not have_key(:GA5)
          }
        end
      end
    end

    describe "GA6" do
      let(:geographical_area) { create(:geographical_area) }

      before {
        geographical_area.parent_geographical_area_group_sid = parent.geographical_area_sid
        geographical_area.conformant?
      }

      context "direct loop between parent-children" do
        let!(:parent) {
          create(:geographical_area, parent_geographical_area_group_sid: geographical_area.geographical_area_sid)
        }

        it {
          expect(geographical_area.conformance_errors).to have_key(:GA6)
        }
      end

      context "two-level loop between parent-children" do
        let!(:parent) {
          child = create(:geographical_area, parent_geographical_area_group_sid: geographical_area.geographical_area_sid)
          create(:geographical_area, parent_geographical_area_group_sid: child.geographical_area_sid)
        }

        it {
          expect(geographical_area.conformance_errors).to have_key(:GA6)
        }
      end
    end
  end

  describe "types of areas" do
    let(:country) do
      build :geographical_area,
            geographical_code: GeographicalArea::GEOGRAPHICAL_COUNTRY_CODE
    end

    let(:group) do
      build :geographical_area,
            geographical_code: GeographicalArea::GEOGRAPHICAL_GROUP_CODE
    end

    let(:region) do
      build :geographical_area,
            geographical_code: GeographicalArea::GEOGRAPHICAL_REGION_CODE
    end

    describe "#group?" do
      it "determines the type from the geographical code" do
        expect(country).to_not be_group
        expect(group).to be_group
        expect(region).to_not be_group
      end
    end

    describe "#country?" do
      it "determines the type from the geographical code" do
        expect(country).to be_country
        expect(group).to_not be_country
        expect(region).to_not be_country
      end
    end

    describe "#region?" do
      it "determines the type from the geographical code" do
        expect(country).to_not be_region
        expect(group).to_not be_region
        expect(region).to be_region
      end
    end
  end
end
