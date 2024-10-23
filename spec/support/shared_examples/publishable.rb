RSpec.shared_examples "publishable" do
  let(:model) { described_class }

  it "has a published scope" do
    expect(model).to respond_to(:published)
  end

  it "has a draft scope" do
    expect(model).to respond_to(:draft)
  end
end
