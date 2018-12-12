require 'rails_helper'

shared_context "regulations_search_base_context" do
  let(:group_aaa) do
    create(:regulation_group, regulation_group_id: "AAA")
  end

  let(:group_bbb) do
    create(:regulation_group, regulation_group_id: "BBB")
  end

  let(:base_i1111111) do
    create(:base_regulation,
      base_regulation_role: 1,
      base_regulation_id: "I1111111",
      information_text: "Base I1111111",
      regulation_group_id: group_aaa.regulation_group_id,
      validity_start_date: 1.year.ago)
  end

  let(:base_i2222222) do
    create(:base_regulation,
      base_regulation_role: 1,
      base_regulation_id: "I2222222",
      information_text: "Base I2222222",
      regulation_group_id: group_bbb.regulation_group_id,
      validity_start_date: 1.year.ago,
      effective_end_date: 1.year.from_now)
  end

  let(:provisional_anti_dumping_i3333333) do
    create(:base_regulation,
      base_regulation_role: 2,
      base_regulation_id: "I3333333",
      information_text: "Provisional anti dumping I3333333",
      regulation_group_id: group_aaa.regulation_group_id,
      antidumping_regulation_role: 1,
      related_antidumping_regulation_id: base_i1111111.base_regulation_id,
      validity_start_date: 1.year.ago)
  end

  let(:definitive_anti_dumping_i4444444) do
    create(:base_regulation,
      base_regulation_role: 3,
      base_regulation_id: "I4444444",
      information_text: "Definitive anti dumping I4444444",
      regulation_group_id: group_bbb.regulation_group_id,
      validity_start_date: 1.year.ago,
      effective_end_date: 1.year.from_now,
      antidumping_regulation_role: 1,
      related_antidumping_regulation_id: base_i2222222.base_regulation_id)
  end

  let(:modification_r5555555) do
    create(:modification_regulation,
      modification_regulation_role: 4,
      modification_regulation_id: "R5555555",
      information_text: "Modification R5555555",
      validity_start_date: 1.year.ago,
      validity_end_date: 5.days.from_now)
  end

  let(:modification_r6666666) do
    create(:modification_regulation,
      modification_regulation_role: 4,
      modification_regulation_id: "R6666666",
      information_text: "Modification R6666666",
      validity_start_date: 1.year.ago,
      validity_end_date: 3.days.from_now)
  end

  let(:prorogation_r9999999) do
    create(:prorogation_regulation,
      prorogation_regulation_role: 5,
      prorogation_regulation_id: "R9999999",
      information_text: "Prorogation R9999999",
      published_date: 10.days.ago)
  end

  let(:complete_abrogation_r7777777) do
    create(:complete_abrogation_regulation,
      complete_abrogation_regulation_role: 6,
      complete_abrogation_regulation_id: "R7777777",
      information_text: "Complete abrogation R7777777",
      published_date: 9.days.ago)
  end

  let(:explicit_abrogation_r8888888) do
    create(:explicit_abrogation_regulation,
      explicit_abrogation_regulation_role: 7,
      explicit_abrogation_regulation_id: "R8888888",
      information_text: "Explicit abrogation R8888888",
      published_date: 1.year.ago)
  end

  let(:full_temporary_stop_r9191919) do
    create(:fts_regulation,
      full_temporary_stop_regulation_role: 8,
      full_temporary_stop_regulation_id: "R9191919",
      information_text: "Full temporary stop R9191919",
      validity_start_date: 1.year.ago)
  end

  before do
    base_i1111111
    base_i2222222
    provisional_anti_dumping_i3333333
    definitive_anti_dumping_i4444444
    modification_r5555555
    modification_r6666666
    complete_abrogation_r7777777
    explicit_abrogation_r8888888
    prorogation_r9999999
    full_temporary_stop_r9191919
  end

  private

  def search_results(search_ops)
    ::RegulationsSearch.new(search_ops)
                       .results
                       .all
                       .sort_by(&:start_date)
  end

  def date_to_format(date_in_string)
    date_in_string.to_date
                  .strftime("%d/%m/%Y")
  end
end
