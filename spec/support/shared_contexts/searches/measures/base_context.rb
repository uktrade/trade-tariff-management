require 'rails_helper'

shared_context "measures_search_base_context" do
  private

  def search_results(ops)
    data = search_key ? { search_key.to_sym => ops } : {}
    ::Measures::Search.new(
      data
    ).results
     .to_a
  end
end
