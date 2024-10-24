require 'rails_helper'

RSpec.describe Listing, type: :model do
  describe 'associations' do
    it { should belong_to(:brand).optional }
    it { should have_one(:address).dependent(:destroy) }
    it { should have_one(:geojson) }
    it { should have_one(:external_listing) }
    it { should have_many(:solutions) }
    it { should have_many(:rooms) }
    it { should have_many(:offers) }
    it { should have_many(:listing_users) }
    it { should have_many(:provider_users).through(:listing_users) }
    it { should have_many(:listing_amenities) }
    it { should have_many(:amenities).through(:listing_amenities) }
    it { should have_one_attached(:main_image) }
    it { should have_many_attached(:gallery_images) }
  end

  describe 'validations' do
    it { should validate_presence_of(:area_description) }
    it { should validate_presence_of(:commuter_description) }
  end

  describe 'enums' do
    it { should define_enum_for(:status).with_values(active: 0, inactive: 1, pending: 2) }
    it { should define_enum_for(:source).with_values(user_generated: 0, external: 1, imported: 2) }
  end

  describe 'scopes' do
    let(:brand) { create(:brand) }
    let(:another_brand) { create(:brand) }

    let!(:external_listing) { create(:listing, brand: brand, source: :external) }
    let!(:user_generated_listing) { create(:listing, brand: brand, source: :user_generated) }
    let!(:active_listing) { create(:listing, brand: brand, status: :active) }
    let!(:inactive_listing) { create(:listing, brand: brand, status: :inactive) }

    describe '.external' do
      it 'returns only external listings' do
        expect(described_class.external).to include(external_listing)
        expect(described_class.external).not_to include(user_generated_listing)
      end
    end

    describe '.user_generated' do
      it 'returns only user generated listings' do
        expect(described_class.user_generated).to include(user_generated_listing)
        expect(described_class.user_generated).not_to include(external_listing)
      end
    end

    describe '.active' do
      it 'returns only active listings' do
        expect(described_class.active).to include(active_listing)
        expect(described_class.active).not_to include(inactive_listing)
      end
    end
  end

  describe 'friendly_id' do
    let(:listing) { create(:listing, name: 'Test Listing') }

    it 'generates slug from name' do
      expect(listing.slug).to eq('test-listing')
    end

    context 'when name changes' do
      it 'updates slug' do
        listing.update(name: 'New Name')
        expect(listing.slug).to eq('new-name')
      end
    end
  end

  describe '#coordinates' do
    let(:listing) { create(:listing) }

    context 'when address exists' do
      let!(:address) { create(:address, :with_coordinates, listing: listing) }

      it 'returns coordinates array from address' do
        coordinates = listing.coordinates
        expect(coordinates[0]).to be_within(1.0).of(18.0686)  # 1 degree longitude tolerance
        expect(coordinates[1]).to be_within(1.0).of(59.3293)  # 1 degree latitude tolerance
      end
    end

    context 'when address does not exist' do
      it 'returns nil' do
        expect(listing.coordinates).to be_nil
      end
    end
  end

  describe '#latitude and #longitude' do
    let(:listing) { create(:listing) }

    context 'when address exists' do
      let!(:address) { create(:address, :with_coordinates, listing: listing) }

      it 'returns latitude from address' do
        expect(listing.latitude).to be_within(1.0).of(59.3293)  # 1 degree tolerance
      end

      it 'returns longitude from address' do
        expect(listing.longitude).to be_within(1.0).of(18.0686)  # 1 degree tolerance
      end
    end

    context 'when address does not exist' do
      it 'returns nil for latitude' do
        expect(listing.latitude).to be_nil
      end

      it 'returns nil for longitude' do
        expect(listing.longitude).to be_nil
      end
    end
  end

  describe '#valid_offers_for_premise_type' do
    let(:listing) { create(:listing) }
    let(:premise_type) { create(:premise_type) }
    let(:offer_category) { create(:offer_category) }
    let!(:valid_offer) do
      create(:offer,
             listing: listing,
             offer_category: offer_category,
             status: :active)
    end
    let!(:invalid_offer) do
      create(:offer,
             listing: listing,
             status: :inactive)
    end

    before do
      premise_type.offer_categories << offer_category
    end

    it 'returns only valid offers for the premise type' do
      valid_offers = listing.valid_offers_for_premise_type(premise_type)
      expect(valid_offers).to include(valid_offer)
      expect(valid_offers).not_to include(invalid_offer)
    end
  end

  describe '.ransackable_attributes' do
    it 'returns the allowed attributes for ransack' do
      expected_attributes = [
        "area_description", "brand_id", "commuter_description",
        "conference_room_request_email", "cost_per_m2", "cost_per_user",
        "created_at", "deleted_at", "description", "description_en",
        "id", "is_premium_listing", "name", "number_of_meeting_rooms",
        "opened", "short_description", "short_description_en",
        "showing_message", "size", "slug", "source", "status",
        "surface_per_user", "updated_at", "url"
      ]
      expect(Listing.ransackable_attributes).to match_array(expected_attributes)
    end
  end

  describe '.ransackable_associations' do
    it 'returns the allowed associations for ransack' do
      expected_associations = [
        "address", "amenities", "brand", "external_listing",
        "geojson", "listings", "rooms", "solutions", "provider_users"
      ]
      expect(Listing.ransackable_associations).to match_array(expected_associations)
    end
  end
end
