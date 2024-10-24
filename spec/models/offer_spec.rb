require 'rails_helper'

RSpec.describe Offer, type: :model do
  describe 'associations' do
    it { should belong_to(:listing) }
    it { should belong_to(:offer_category) }
    it { should have_many(:offer_versions) }
    it { should have_many(:offer_excluded_amenities) }
    it { should have_many(:excluded_amenities).through(:offer_excluded_amenities).source(:amenity) }
    it { should have_many(:offer_paid_amenities) }
    it { should have_many(:paid_amenities).through(:offer_paid_amenities).source(:amenity) }
  end

  describe 'validations' do
    it { should validate_presence_of(:offer_category) }
  end

  describe 'enums' do
    it { should define_enum_for(:status).with_values(active: 0, inactive: 1, pending: 2) }
    it { should define_enum_for(:offer_type).with_values(daily: 0, monthly: 1, yearly: 2) }
  end

  describe 'scopes' do
    let!(:active_offer) { create(:offer, status: :active) }
    let!(:inactive_offer) { create(:offer, status: :inactive) }
    let!(:pending_offer) { create(:offer, status: :pending) }

    describe '.active' do
      it 'returns only active offers' do
        expect(described_class.active).to include(active_offer)
        expect(described_class.active).not_to include(inactive_offer, pending_offer)
      end
    end
  end

  describe 'soft delete' do
    let(:offer) { create(:offer) }

    it 'soft deletes the record' do
      expect { offer.destroy }.to change { offer.reload.deleted_at }.from(nil)
    end

    it 'can be restored' do
      offer.destroy
      expect { offer.restore }.to change { offer.reload.deleted_at }.to(nil)
    end
  end

  describe '.ransackable_attributes' do
    it 'returns the correct ransackable attributes' do
      expected_attributes = [
        "created_at", "deleted_at", "id", "listing_id", "name", "slug",
        "updated_at", "status", "type", "offer_category_id"
      ]
      expect(described_class.ransackable_attributes).to match_array(expected_attributes)
    end
  end

  describe '.ransackable_associations' do
    it 'returns the correct ransackable associations' do
      expected_associations = [
        "listing", "offer_category", "offer_excluded_amenities",
        "offer_paid_amenities", "offer_versions", "excluded_amenities",
        "paid_amenities"
      ]
      expect(described_class.ransackable_associations).to match_array(expected_associations)
    end
  end

  describe '#category' do
    let(:offer_category) { create(:offer_category, name: 'Test Category') }
    let(:offer) { create(:offer, offer_category: offer_category) }

    it 'returns the offer category name' do
      expect(offer.category).to eq('Test Category')
    end

    context 'when offer_category is nil' do
      let(:offer) { build(:offer, offer_category: nil) }

      it 'returns nil' do
        expect(offer.category).to be_nil
      end
    end
  end
end
