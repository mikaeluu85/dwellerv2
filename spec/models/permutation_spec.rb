RSpec.describe Permutation, type: :model do
  describe '#matching_offers' do
    let(:premise_type) { create(:premise_type) }
    let(:location) { create(:location) }
    let(:valid_category) { create(:offer_category) }
    let(:invalid_category) { create(:offer_category) }
    let(:permutation) { create(:permutation, premise_type: premise_type, location: location) }
    let(:listing) { create(:listing, premise_type: premise_type) }
    
    before do
      premise_type.offer_categories << valid_category
      create(:address, city: location.name, listing: listing)
      create(:offer, listing: listing, offer_category: valid_category, status: :active)
      create(:offer, listing: listing, offer_category: invalid_category, status: :active)
    end

    it 'only returns offers with matching categories' do
      matching_offers = permutation.matching_offers
      expect(matching_offers.count).to eq(1)
      expect(matching_offers.first.offer_category).to eq(valid_category)
    end
  end

  describe '#filtered_listings' do
    let(:premise_type) { create(:premise_type) }
    let(:location) { create(:location) }
    let(:valid_category) { create(:offer_category) }
    let(:permutation) { create(:permutation, premise_type: premise_type, location: location) }
    
    before do
      premise_type.offer_categories << valid_category
      @listing = create(:listing, premise_type: premise_type)
      create(:address, city: location.name, listing: @listing)
      create(:offer, listing: @listing, offer_category: valid_category, status: :active)
    end

    it 'returns listings with valid offers' do
      filtered_listings = permutation.filtered_listings
      expect(filtered_listings).to include(@listing)
    end
  end

  describe 'offer category filtering' do
    let(:premise_type) { create(:premise_type) }
    let(:location) { create(:location) }
    let(:permutation) { create(:permutation, premise_type: premise_type, location: location) }
    let(:valid_category) { create(:offer_category) }
    let(:invalid_category) { create(:offer_category) }
    let(:listing) { create(:listing, premise_type: premise_type) }

    before do
      # Explicitly set up the association
      premise_type.offer_categories = [valid_category]
      
      # Create an address for the listing
      create(:address, city: location.name, listing: listing)
      
      # Create offers with different categories
      create(:offer, 
             listing: listing, 
             offer_category: valid_category, 
             status: :active)
      
      create(:offer, 
             listing: listing, 
             offer_category: invalid_category, 
             status: :active)
    end

    it 'only shows offers with categories assigned to the premise type' do
      offers = permutation.matching_offers
      
      # Debug output
      puts "Premise Type Offer Category IDs: #{premise_type.offer_category_ids}"
      puts "Valid Category ID: #{valid_category.id}"
      puts "Invalid Category ID: #{invalid_category.id}"
      puts "Returned Offer Category IDs: #{offers.pluck(:offer_category_id)}"
      
      expect(offers.pluck(:offer_category_id)).to contain_exactly(valid_category.id)
      expect(offers.pluck(:offer_category_id)).not_to include(invalid_category.id)
    end
  end
end
