require 'rails_helper'

RSpec.describe Location, type: :model do
  describe 'spatial queries' do
    let!(:stockholm) { create(:location, :in_stockholm) }
    let!(:gothenburg) { create(:location, :in_gothenburg) }

    describe '.within_distance_of' do
      it 'finds locations within specified distance' do
        point = create_point(18.0686, 59.3293) # Stockholm coordinates
        nearby = Location.within_distance_of(point, 10000) # 10km radius

        expect(nearby).to include(stockholm)
        expect(nearby).not_to include(gothenburg)
      end
    end

    describe 'distance calculations' do
      it 'calculates correct distance between points' do
        distance = distance_between_points(
          stockholm.coordinates,
          gothenburg.coordinates
        )

        # Distance should be approximately 400km
        expect(distance / 1000).to be_within(10).of(400)
      end
    end
  end
end
