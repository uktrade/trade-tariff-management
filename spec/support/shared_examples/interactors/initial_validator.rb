shared_examples :an_initial_validator do
  it "conforms to the initial validator interface" do
    expect(described_class.public_instance_methods(false))
      .to include :fetch_errors, :errors_summary, :errors_translator
  end
end
