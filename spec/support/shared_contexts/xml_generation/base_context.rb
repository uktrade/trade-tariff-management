require 'rails_helper'

shared_context "xml_generation_base_context" do
  let!(:xml_envelope) do
    create(:xml_generation_node_envelope)
  end

  let!(:xml_transaction) do
    create(:xml_generation_node_transaction, envelope: xml_envelope)
  end

  let(:xml_builder) do
    Builder::XmlMarkup.new
  end

  let(:main_template_path) do
    "#{Rails.root}/app/views/xml_generation/templates/main.builder"
  end

  let(:xml_renderer) do
    Tilt.new(main_template_path)
  end

  let(:xml_body) do
    xml_renderer.render(xml_envelope.reload, xml: xml_builder)
  end

  let(:hash_xml) do
    Hash.from_xml(xml_body)
  end

  def record_filter_ops(record_class, record)
    res = {}
    primary_key = record_class.constantize.primary_key

    if primary_key.is_a?(Array)
      primary_key.select do |k|
        !k.to_s.include?("_date") &&
        !k.to_s.include?("_timestamp")
      end.map do |key|
        res[key.to_s] = record.send(key)
      end
    else
      res[primary_key.to_s] = record.public_send(primary_key)
    end

    res
  end
end
