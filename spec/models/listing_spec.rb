require 'rails_helper'

RSpec.describe Listing, type: :model do
  describe 'associations' do
    it { should belong_to(:brand) }
    it { should have_many(:offers).dependent(:destroy) }
    it { should have_many(:rooms).dependent(:destroy) }
    it { should have_one(:address).dependent(:destroy) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:size) }
    it { should validate_numericality_of(:size).is_greater_than(0) }
  end

  describe 'scopes' do
    let!(:active_listing) { create(:listing, status: :active) }
    let!(:inactive_listing) { create(:listing, status: :inactive) }

    describe '.active' do
      it 'returns only active listings' do
        expect(described_class.active).to include(active_listing)
        expect(described_class.active).not_to include(inactive_listing)
      end
    end
  end

  describe '#calculate_total_price' do
    let(:listing) { create(:listing, cost_per_m2: 100, size: 50) }

    it 'calculates the total price correctly' do
      expect(listing.calculate_total_price).to eq(5000)
    end
  end
end
