require 'rails_helper'

require 'chief_importer'
require 'chief_importer/change_entry'

# Define a test strategy
class ChiefImporter
  module Strategies
    class TestStrategy < BaseStrategy
    end
  end
end

describe ChiefImporter::ChangeEntry do
  let(:valid_table_name)     { 'TestStrategy' }
  let(:invalid_table_name)   { 'errr' }
  let(:valid_args)           { [valid_table_name] }
  let(:invalid_args)         { [invalid_table_name] }

  describe 'initialization' do
    before(:all) do
      # make TestStrategy a valid one
      ChiefImporter.relevant_tables.push("TestStrategy")
    end

    it 'assigns table name' do
      ce = described_class.new(valid_args)
      expect(ce.table).to eq valid_table_name
    end

    it 'assigns proper available strategy' do
      ce = described_class.new(invalid_args)
      expect(ce.table).to eq invalid_table_name
      expect(ce.strategy).to be_blank

      ce = described_class.new(valid_args)
      expect(ce.table).to eq valid_table_name
      expect(ce.strategy).not_to be_blank
      expect(ce.strategy).to be_kind_of ChiefImporter::Strategies::TestStrategy
    end
  end

  describe "#relevant?" do
    it 'returns false if table is relevant' do
      expect(
        described_class.new(invalid_args)
      ).not_to be_relevant
    end

    it 'returns true if table is relevant' do
      ChiefImporter.relevant_tables += valid_args

      expect(
        described_class.new(valid_args)
      ).to be_relevant
    end
  end
end
