require 'rails_helper'

shared_context "measures_search_base_context" do
  private

  def search_results(ops)
    ::Measures::Search.new(
      search_key.to_sym => ops
    ).results
     .to_a
  end
end
