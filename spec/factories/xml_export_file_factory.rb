FactoryBot.define do
  factory :xml_export_file, class: "XmlExport::File" do
    state { "G" }
    issue_date { 2.days.ago }
    workbasket { true }
  end
end
