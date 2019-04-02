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

    it "shows all measures" do
      res = search_results
      expect(res.count).to eq 3
    end
  end

  def search_results
    ::Quotas::Search.new({}).results.to_a
  end
end
