require 'rails_helper'

RSpec.describe ListingsController, type: :controller do
  describe 'GET #index' do
    let!(:listings) { create_list(:listing, 3, status: :active) }

    it 'returns successful response' do
      get :index
      expect(response).to be_successful
    end

    it 'assigns @listings' do
      get :index
      expect(assigns(:listings)).to match_array(listings)
    end
  end

  describe 'GET #show' do
    let(:listing) { create(:listing) }

    it 'returns successful response' do
      get :show, params: { id: listing.id }
      expect(response).to be_successful
    end

    it 'assigns @listing' do
      get :show, params: { id: listing.id }
      expect(assigns(:listing)).to eq(listing)
    end
  end
end
