require 'rails_helper'

RSpec.describe PermutationsController, type: :controller do
  describe "GET #show" do
    let(:permutation) { create(:permutation) }
    let!(:listings) { create_list(:listing, 15, address: create(:address, latitude: 59.3293, longitude: 18.0686)) }

    before do
      allow_any_instance_of(Permutation).to receive(:listings_within_location).and_return(Listing.all)
    end

    it "assigns @permutation" do
      get :show, params: { id: permutation.id }
      expect(assigns(:permutation)).to eq(permutation)
    end

    it "assigns @listings" do
      get :show, params: { id: permutation.id }
      expect(assigns(:listings).count).to eq(12) # Default per page
    end

    it "renders the show template" do
      get :show, params: { id: permutation.id }
      expect(response).to render_template(:show)
    end

    it "responds to turbo_stream format" do
      get :show, params: { id: permutation.id }, format: :turbo_stream
      expect(response.content_type).to eq("text/vnd.turbo-stream.html; charset=utf-8")
    end
  end
end
