require 'rails_helper'

RSpec.describe Provider, type: :model do
  describe 'associations' do
    it { should have_many(:brands) }
    it { should have_many(:provider_users) }
    it { should have_many(:listings).through(:brands) }
    it { should have_one_attached(:logo) }
  end

  describe 'validations' do
    subject { build(:provider) }

    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:ovid).allow_blank }
    it { should validate_uniqueness_of(:woid).allow_blank }

    context 'format validations' do
      it 'validates postal_code format' do
        provider = build(:provider)

        provider.postal_code = '12345'
        expect(provider).to be_valid

        provider.postal_code = '1234'
        expect(provider).not_to be_valid
        expect(provider.errors[:postal_code]).to include('should be 5 digits')

        provider.postal_code = ''
        expect(provider).to be_valid
      end

      it 'validates organizational_number format' do
        provider = build(:provider)

        provider.organizational_number = '123456-7890'
        expect(provider).to be_valid

        provider.organizational_number = '12345-7890'
        expect(provider).not_to be_valid
        expect(provider.errors[:organizational_number]).to include('should be in the format XXXXXX-XXXX')

        provider.organizational_number = ''
        expect(provider).to be_valid
      end

      it 'validates email formats' do
        provider = build(:provider)

        [ 'invoice_email', 'contact_email' ].each do |email_field|
          provider.send("#{email_field}=", 'valid@example.com')
          expect(provider).to be_valid

          provider.send("#{email_field}=", 'invalid-email')
          expect(provider).not_to be_valid
          expect(provider.errors[email_field]).to include('is invalid')

          provider.send("#{email_field}=", '')
          expect(provider).to be_valid
        end
      end
    end
  end

  describe 'scopes' do
    let!(:active_provider) { create(:provider) }
    let!(:deleted_provider) { create(:provider) }

    before do
      deleted_provider.destroy # Soft delete the provider
    end

    describe '.active' do
      it 'returns only active providers' do
        expect(Provider.active).to include(active_provider)
        expect(Provider.active).not_to include(deleted_provider)
      end
    end

    describe '.deleted' do
      it 'returns only deleted providers' do
        expect(Provider.with_deleted.only_deleted).to include(deleted_provider)
        expect(Provider.with_deleted.only_deleted).not_to include(active_provider)
      end
    end
  end

  describe '.ransackable_attributes' do
    it 'returns the allowed attributes for ransack' do
      expected_attributes = [
        "created_at", "deleted_at", "id", "name", "updated_at",
        "ovid", "postal_code", "city", "organizational_number",
        "street", "invoice_email", "woid", "website", "contact_email"
      ]
      expect(Provider.ransackable_attributes).to match_array(expected_attributes)
    end
  end

  describe '.ransackable_associations' do
    it 'returns the allowed associations for ransack' do
      expected_associations = [ "brands", "provider_users", "logo_attachment", "logo_blob" ]
      expect(Provider.ransackable_associations).to match_array(expected_associations)
    end
  end

  describe '#count_active_listings_with_active_offers' do
    let(:provider) { create(:provider) }
    let(:brand) { create(:brand, provider: provider) }

    let!(:active_listing_with_active_offer) do
      listing = create(:listing, brand: brand, status: :active)
      create(:offer, listing: listing, status: :active)
      listing
    end

    let!(:active_listing_with_inactive_offer) do
      listing = create(:listing, brand: brand, status: :active)
      create(:offer, listing: listing, status: :inactive)
      listing
    end

    let!(:inactive_listing_with_active_offer) do
      listing = create(:listing, brand: brand, status: :inactive)
      create(:offer, listing: listing, status: :active)
      listing
    end

    it 'returns the correct count of active listings with active offers' do
      expect(provider.count_active_listings_with_active_offers).to eq(1)
    end
  end
end
