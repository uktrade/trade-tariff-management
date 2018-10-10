require 'rails_helper'

shared_context "xml_generation_base_context" do
  let(:xml_node) do
    ::XmlGeneration::NodeEnvelope.new(workbasket.settings.collection)
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
    xml_renderer.render(xml_node, xml: xml_builder)
  end

  let(:hash_xml) do
    Hash.from_xml(xml_body)
  end
end
