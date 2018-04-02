FactoryGirl.define do
  factory :xml_generation_node_envelope, class: XmlGeneration::NodeEnvelope do
  end

  factory :xml_generation_node_transaction, class: XmlGeneration::NodeTransaction do
    node_envelope_id    { Forgery(:basic).text(exactly: 3) }
  end

  factory :xml_generation_node_message, class: XmlGeneration::NodeMessage do
    node_transaction_id { Forgery(:basic).text(exactly: 3) }
    record_filter_ops   { }
    record_type         { "Measure" }
  end
end
