require "rails_helper"

describe "Searches: Regulations search" do

  let!(:group_aaa) do
    create(:regulation_group, regulation_group_id: "AAA")
  end

  let!(:group_bbb) do
    create(:regulation_group, regulation_group_id: "BBB")
  end

  let!(:base_i1111111) do
    create(:base_regulation,
      base_regulation_role: 1,
      base_regulation_id: "I1111111",
      information_text: "Base I1111111",
      regulation_group_id: group_aaa.regulation_group_id,
      validity_start_date: 1.year.ago
    )
  end

  let!(:base_i2222222) do
    create(:base_regulation,
      base_regulation_role: 1,
      base_regulation_id: "I2222222",
      information_text: "Base I2222222",
      regulation_group_id: group_bbb.regulation_group_id,
      validity_start_date: 1.year.ago,
      effective_end_date: 1.year.from_now
    )
  end

  let!(:provisional_anti_dumping_i3333333) do
    create(:base_regulation,
      base_regulation_role: 2,
      base_regulation_id: "I3333333",
      information_text: "Provisional anti dumping I3333333",
      regulation_group_id: group_aaa.regulation_group_id,
      antidumping_regulation_role: 1,
      related_antidumping_regulation_id: base_i1111111.base_regulation_id,
      validity_start_date: 1.year.ago
    )
  end

  let!(:definitive_anti_dumping_i4444444) do
    create(:base_regulation,
      base_regulation_role: 3,
      base_regulation_id: "I4444444",
      information_text: "Definitive anti dumping I4444444",
      regulation_group_id: group_bbb.regulation_group_id,
      validity_start_date: 1.year.ago,
      effective_end_date: 1.year.from_now,
      antidumping_regulation_role: 1,
      related_antidumping_regulation_id: base_i2222222.base_regulation_id
    )
  end

  let!(:modification_r5555555) do
    create(:modification_regulation,
      modification_regulation_role: 4,
      modification_regulation_id: "R5555555",
      information_text: "Modification R5555555",
      validity_start_date: 1.year.ago,
      validity_end_date: 5.days.from_now
    )
  end

  let!(:modification_r6666666) do
    create(:modification_regulation,
      modification_regulation_role: 4,
      modification_regulation_id: "R6666666",
      information_text: "Modification R6666666",
      validity_start_date: 1.year.ago,
      validity_end_date: 3.days.from_now
    )
  end

  let!(:prorogation_r9999999) do
    create(:prorogation_regulation,
      prorogation_regulation_role: 5,
      prorogation_regulation_id: "R9999999",
      information_text: "Prorogation R9999999",
      published_date: 10.days.ago
    )
  end

  let!(:complete_abrogation_r7777777) do
    create(:complete_abrogation_regulation,
      complete_abrogation_regulation_role: 6,
      complete_abrogation_regulation_id: "R7777777",
      information_text: "Complete abrogation R7777777",
      published_date: 9.days.ago
    )
  end

  let!(:explicit_abrogation_r8888888) do
    create(:explicit_abrogation_regulation,
      explicit_abrogation_regulation_role: 7,
      explicit_abrogation_regulation_id: "R8888888",
      information_text: "Explicit abrogation R8888888",
      published_date: 1.year.ago
    )
  end

  let!(:full_temporary_stop_r9191919) do
    create(:fts_regulation,
      full_temporary_stop_regulation_role: 8,
      full_temporary_stop_regulation_id: "R9191919",
      information_text: "Full temporary stop R9191919",
      validity_start_date: 1.year.ago
    )
  end

  describe "Index" do
    it "should return all regulations" do
      results = search_results({})
      expect(results.count).to be_eql(10)
    end
  end

  describe "Role filter" do
    it "should filter by role" do
      results = search_results(role: 1)
      expect(results.count).to be_eql(2)
      expect(results[0].regulation_id).to be_eql(base_i1111111.base_regulation_id)
      expect(results[1].regulation_id).to be_eql(base_i2222222.base_regulation_id)

      results = search_results(role: 2)
      expect(results.count).to be_eql(1)
      expect(results[0].regulation_id).to be_eql(provisional_anti_dumping_i3333333.base_regulation_id)

      results = search_results(role: 3)
      expect(results.count).to be_eql(1)
      expect(results[0].regulation_id).to be_eql(definitive_anti_dumping_i4444444.base_regulation_id)

      results = search_results(role: 4)
      expect(results.count).to be_eql(2)
      expect(results[0].regulation_id).to be_eql(modification_r5555555.modification_regulation_id)
      expect(results[1].regulation_id).to be_eql(modification_r6666666.modification_regulation_id)

      results = search_results(role: 5)
      expect(results.count).to be_eql(1)
      expect(results[0].regulation_id).to be_eql(prorogation_r9999999.prorogation_regulation_id)

      results = search_results(role: 6)
      expect(results.count).to be_eql(1)
      expect(results[0].regulation_id).to be_eql(complete_abrogation_r7777777.complete_abrogation_regulation_id)

      results = search_results(role: 7)
      expect(results.count).to be_eql(1)
      expect(results[0].regulation_id).to be_eql(explicit_abrogation_r8888888.explicit_abrogation_regulation_id)

      results = search_results(role: 8)
      expect(results.count).to be_eql(1)
      expect(results[0].regulation_id).to be_eql(full_temporary_stop_r9191919.full_temporary_stop_regulation_id)
    end
  end

  describe "Regulation group filter" do
    it "should filter by regulation_group_id" do
      results = search_results(regulation_group_id: group_aaa.regulation_group_id)
      expect(results.count).to be_eql(2)
      expect(results[0].regulation_id).to be_eql(base_i1111111.base_regulation_id)
      expect(results[1].regulation_id).to be_eql(provisional_anti_dumping_i3333333.base_regulation_id)

      results = search_results(regulation_group_id: group_bbb.regulation_group_id)
      expect(results.count).to be_eql(2)
      expect(results[0].regulation_id).to be_eql(base_i2222222.base_regulation_id)
      expect(results[1].regulation_id).to be_eql(definitive_anti_dumping_i4444444.base_regulation_id)
    end
  end

  describe "Start / End date filter" do
    it "should filter by start date" do
      results = search_results(start_date: date_to_format(11.days.ago))
      expect(results.count).to be_eql(2)
      expect(results[0].regulation_id).to be_eql(prorogation_r9999999.prorogation_regulation_id)
      expect(results[1].regulation_id).to be_eql(complete_abrogation_r7777777.complete_abrogation_regulation_id)

      results = search_results(start_date: date_to_format(9.days.ago))
      expect(results.count).to be_eql(1)
      expect(results[0].regulation_id).to be_eql(complete_abrogation_r7777777.complete_abrogation_regulation_id)
    end

    it "should filter by end date" do
      results = search_results(end_date: date_to_format(5.days.from_now))
      expect(results.count).to be_eql(2)
      expect(results[0].regulation_id).to be_eql(modification_r5555555.modification_regulation_id)
      expect(results[1].regulation_id).to be_eql(modification_r6666666.modification_regulation_id)

      results = search_results(end_date: date_to_format(3.days.from_now))
      expect(results.count).to be_eql(1)
      expect(results[0].regulation_id).to be_eql(modification_r6666666.modification_regulation_id)
    end

    it "should filter by start date and end date" do
      results = search_results(
        start_date: date_to_format(1.year.ago),
        end_date: date_to_format(5.days.from_now)
      )

      expect(results.count).to be_eql(2)
      expect(results[0].regulation_id).to be_eql(modification_r5555555.modification_regulation_id)
      expect(results[1].regulation_id).to be_eql(modification_r6666666.modification_regulation_id)
    end
  end

  describe "Keywords filter" do
    it "should filter by keywords" do
      results = search_results(keywords: "Modific")
      expect(results.count).to be_eql(2)
      expect(results[0].regulation_id).to be_eql(modification_r5555555.modification_regulation_id)
      expect(results[1].regulation_id).to be_eql(modification_r6666666.modification_regulation_id)

      results = search_results(keywords: "R9999")
      expect(results.count).to be_eql(1)
      expect(results[0].regulation_id).to be_eql(prorogation_r9999999.prorogation_regulation_id)

      results = search_results(keywords: "Full temporary")
      expect(results.count).to be_eql(1)
      expect(results[0].regulation_id).to be_eql(full_temporary_stop_r9191919.full_temporary_stop_regulation_id)
    end
  end

  private

    def search_results(search_ops)
      ::RegulationsSearch.new(search_ops)
                         .results
                         .all
    end

    def date_to_format(date_in_string)
      date_in_string.to_date
                    .strftime("%d/%m/%Y")
    end
end
