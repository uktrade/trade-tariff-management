require 'rails_helper'

shared_context 'regulation_page_context' do

  include_context 'system_test_base_context'

  def visit_create_regulation
    visit root_path
    click_on 'Create a regulation'
  end

end
