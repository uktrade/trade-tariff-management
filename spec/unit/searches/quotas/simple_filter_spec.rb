require "rails_helper"

describe "Quota search: simple filters" do
  let!(:a_quota_definition) do
    create(:quota_definition, status: 'published')
  end

  let!(:b_quota_definition) do
    create(:quota_definition, status: 'published')
  end

  let!(:c_quota_definition) do
    create(:quota_definition, status: 'published')
  end
  
  describe "published quotas" do

    it "shows all published measures" do
      res = search_results
      expect(res.count).to eq 3
    end

    it "does not show measures that are not published" do
      c_quota_definition.status = 'awaiting_cross_check'
      c_quota_definition.save
      res = search_results
      statuses = res.map(&:status)

      expect(res.count).to eq 2
      expect(statuses.include?('awaiting_cross_check')).to eq false
    end
  end

  def search_results
    ::Quotas::Search.new({}).results.to_a
  end
end
