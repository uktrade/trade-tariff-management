require 'rails_helper'

shared_context "xml_generation_record_context" do

  include_context "xml_generation_base_context"

  let(:xml_record) do
    hash_xml["env:envelope"]["env:transaction"]["env:app.message"]["oub:transmission"]["oub:record"]
  end

  let(:xml_values) do
    xml_record[data_namespace]
  end

  let!(:workbasket) do
    create(:workbasket, :create_measures)
  end

  before do
    workbasket

    db_record.workbasket_id = workbasket.id
    db_record.workbasket_sequence_number = 1
    db_record.status = "awaiting_cross_check"
    db_record.save

    db_record.reload
    workbasket.reload

    settings = workbasket.settings
    allow(settings).to receive(:collection) { [db_record] }
  end

  it "should return valid XML" do
    fields_to_check.map do |_field_name|
      p ""
      p "#{_field_name}: #{_field_name}"
      p ""

      expect_proper_xml_at(_field_name)
    end
  end

  private

    def expect_proper_xml_at(field_ops)
      field_name = (field_ops.is_a?(Hash) ? field_ops.values[0] : field_ops).to_s
      data_field_name = field_ops.is_a?(Hash) ? field_ops.keys[0] : field_ops
      date_type = field_name[-5..-1] == "_date"

      xml_name = "oub:#{field_name.gsub('_', '.')}"
      xml_value = db_record.public_send(data_field_name)
      xml_value = xml_value.strftime("%Y-%m-%d") if date_type

      expect(xml_values[xml_name]).to be_eql xml_value.to_s
    end
end
