require 'rails_helper'

RSpec.describe PermutationsController, type: :controller do
  let(:user) { create(:admin_user) }
  let(:premise_type) { create(:premise_type) }
  let(:location) { create(:location) }
  let(:permutation) { create(:permutation, premise_type: premise_type, location: location) }
  
  before do
    sign_in user
  end

  describe 'GET #show' do
    context 'with valid permutation' do
      before do
        allow(controller).to receive(:authorize).and_return(true)
      end

      it 'assigns the requested permutation' do
        get :show, params: { premise_type: premise_type.slug, location_name: location.slug }
        expect(assigns(:permutation)).to eq(permutation)
      end

      it 'assigns listings data' do
        create_list(:listing, 3, :with_active_offers, location: location)
        
        get :show, params: { premise_type: premise_type.slug, location_name: location.slug }
        
        expect(assigns(:listings)).to be_present
        expect(assigns(:listings_count)).to be_positive
      end

      it 'sets SEO data' do
        get :show, params: { premise_type: premise_type.slug, location_name: location.slug }
        
        expect(assigns(:custom_data)).to include('seo_title', 'seo_description')
      end

      context 'with caching' do
        it 'caches the permutation lookup' do
          expect(Rails.cache).to receive(:fetch)
            .with("permutation/#{premise_type.slug}/#{location.slug}", any_args)
            .and_return(permutation)

          get :show, params: { premise_type: premise_type.slug, location_name: location.slug }
        end

        it 'caches the listings data' do
          expect(Rails.cache).to receive(:fetch)
            .with(/permutation\/.*\/listings/, any_args)
            .and_return({ listings: [], count: 0 })

          get :show, params: { premise_type: premise_type.slug, location_name: location.slug }
        end

        it 'skips cache in development with skip_cache param' do
          allow(Rails.env).to receive(:development?).and_return(true)
          
          expect(Rails.cache).not_to receive(:fetch)
          
          get :show, params: { 
            premise_type: premise_type.slug, 
            location_name: location.slug,
            skip_cache: '1'
          }
        end
      end
    end

    context 'with invalid permutation' do
      it 'redirects to root with flash message' do
        get :show, params: { premise_type: 'invalid', location_name: 'invalid' }
        
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to be_present
      end
    end

    context 'with no listings' do
      it 'redirects to root with notice' do
        get :show, params: { premise_type: premise_type.slug, location_name: location.slug }
        
        expect(response).to redirect_to(root_path)
        expect(flash[:notice]).to be_present
      end
    end
  end
end
