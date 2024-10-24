require 'rails_helper'

RSpec.describe Solution, type: :model do
  let(:provider) { create(:provider) }
  let(:brand) { create(:brand, provider: provider) }
  let(:listing) do
    create(:listing,
      brand: brand,
      name: 'Test Listing',
      area_description: 'Area',
      commuter_description: 'Commuter'
    )
  end

  describe 'associations' do
    it { should belong_to(:listing) }
    it { should have_many(:solution_rooms).dependent(:destroy) }
    it { should have_many(:rooms).through(:solution_rooms) }
    it { should have_one_attached(:thumbnail) }
  end

  describe 'nested attributes' do
    it { should accept_nested_attributes_for(:solution_rooms).allow_destroy(true) }
  end

  describe 'scopes' do
    let!(:active_solution) do
      create(:solution,
        listing: listing,
        deleted_at: nil
      )
    end

    let!(:deleted_solution) do
      create(:solution,
        listing: listing,
        deleted_at: Time.current
      )
    end

    describe '.active' do
      it 'returns solutions that are not deleted' do
        expect(Solution.active).to include(active_solution)
        expect(Solution.active).not_to include(deleted_solution)
      end
    end

    describe '.deleted' do
      it 'returns solutions that are deleted' do
        expect(Solution.deleted).to include(deleted_solution)
        expect(Solution.deleted).not_to include(active_solution)
      end
    end
  end

  describe '.ransackable_attributes' do
    it 'returns the allowed attributes for ransack' do
      expected_attributes = [ "created_at", "id", "listing_id", "name", "updated_at" ]
      expect(Solution.ransackable_attributes).to match_array(expected_attributes)
    end
  end

  describe '.ransackable_associations' do
    it 'returns the allowed associations for ransack' do
      expected_associations = [ "listing", "rooms", "solution_rooms" ]
      expect(Solution.ransackable_associations).to match_array(expected_associations)
    end
  end
end
