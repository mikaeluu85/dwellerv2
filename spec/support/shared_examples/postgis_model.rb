RSpec.shared_examples "postgis_model" do
  it { should have_db_column(:coordinates).of_type(:geometry) }

  describe "spatial queries" do
    let(:model) { described_class }
    let(:point) { valid_geojson_point }

    it "can perform within distance queries" do
      expect(model).to respond_to(:within_distance_of)
    end

    it "can perform contains queries" do
      expect(model).to respond_to(:contains_point)
    end
  end
end
