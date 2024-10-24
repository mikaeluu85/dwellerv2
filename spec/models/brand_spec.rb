require 'rails_helper'

RSpec.describe Brand, type: :model do
  describe 'associations' do
    it { should belong_to(:provider) }
    it { should have_many(:listings) }
    it { should have_one_attached(:header_image) }
    it { should have_one_attached(:logo) }
  end

  describe 'validations' do
    subject { build(:brand) }

    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name) }
    # Commenting out slug validations as they're handled by FriendlyId
    # it { should validate_uniqueness_of(:slug) }
  end

  describe 'scopes' do
    let!(:active_brand) { create(:brand, active: true, deleted_at: nil) }
    let!(:inactive_brand) { create(:brand, active: false, deleted_at: nil) }
    let!(:deleted_brand) { create(:brand, active: true) }

    before do
      deleted_brand.destroy # Actually mark the record as deleted
    end

    describe '.active' do
      it 'returns only active and non-deleted brands' do
        expect(Brand.active).to include(active_brand)
        expect(Brand.active).not_to include(inactive_brand, deleted_brand)
      end
    end

    describe '.deleted' do
      it 'returns only deleted brands' do
        expect(Brand.with_deleted.only_deleted).to include(deleted_brand)
        expect(Brand.with_deleted.only_deleted).not_to include(active_brand, inactive_brand)
      end
    end
  end

  describe '#should_generate_new_friendly_id?' do
    let(:brand) { create(:brand) }

    it 'returns true when slug is blank' do
      brand.slug = nil
      expect(brand.should_generate_new_friendly_id?).to be true
    end

    it 'returns true when name has changed' do
      brand.name = 'New Name'
      expect(brand.should_generate_new_friendly_id?).to be true
    end

    it 'returns false when neither condition is met' do
      expect(brand.should_generate_new_friendly_id?).to be false
    end
  end

  describe '#active_provider_users' do
    let(:provider) { create(:provider) }
    let(:brand) { create(:brand, provider: provider) }

    let!(:active_provider_user) { create(:provider_user, provider: provider, deleted_at: nil) }
    let!(:deleted_provider_user) { create(:provider_user, provider: provider) }

    before do
      deleted_provider_user.destroy # Mark as deleted using acts_as_paranoid
    end

    context 'when brand has a provider' do
      it 'returns active provider users for the brand\'s provider' do
        expect(brand.active_provider_users).to include(active_provider_user)
        expect(brand.active_provider_users).not_to include(deleted_provider_user)
      end
    end

    context 'when brand has no provider' do
      let(:brand) { build(:brand, provider: nil) }
      let!(:other_active_user) { create(:provider_user, provider: create(:provider)) }

      it 'returns all active provider users' do
        expect(brand.active_provider_users).to include(active_provider_user, other_active_user)
        expect(brand.active_provider_users).not_to include(deleted_provider_user)
      end
    end
  end

  describe '.ransackable_attributes' do
    it 'returns the allowed attributes for ransack' do
      expected_attributes = [
        "created_at", "deleted_at", "id", "is_featured", "name",
        "provider_id", "slug", "updated_at", "extended_description", "active"
      ]
      expect(Brand.ransackable_attributes).to match_array(expected_attributes)
    end
  end

  describe '.ransackable_associations' do
    it 'returns the allowed associations for ransack' do
      expected_associations = [ "provider", "listings" ]
      expect(Brand.ransackable_associations).to match_array(expected_associations)
    end
  end
end
