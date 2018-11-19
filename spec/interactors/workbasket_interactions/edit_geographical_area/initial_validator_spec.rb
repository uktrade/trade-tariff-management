require "rails_helper"
require "support/shared_examples/interactors/initial_validator"

describe WorkbasketInteractions::EditGeographicalArea::InitialValidator do
  it_behaves_like :an_initial_validator
end
