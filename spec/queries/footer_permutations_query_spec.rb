# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FooterPermutationsQuery do
  describe '.fetch' do
    let!(:prioritized_location) { create(:location, prioritized: true) }
    let!(:non_prioritized_location) { create(:location, prioritized: false) }
    let!(:premise_type) { create(:premise_type) }
    let!(:another_premise_type) { create(:premise_type) }

    let!(:prioritized_permutation) do
      create(:permutation,
             premise_type: premise_type,
             location: prioritized_location)
    end

    let!(:another_prioritized_permutation) do
      create(:permutation,
             premise_type: another_premise_type,
             location: prioritized_location)
    end

    let!(:non_prioritized_permutation) do
      create(:permutation,
             premise_type: premise_type,
             location: non_prioritized_location)
    end

    it 'returns premise types with their prioritized permutations' do
      result = described_class.fetch

      expected_result = {
        premise_type => premise_type.permutations.where(location: prioritized_location),
        another_premise_type => another_premise_type.permutations.where(location: prioritized_location)
      }

      expect(result.keys).to match_array(expected_result.keys)
      result.each do |premise_type, permutations|
        expect(permutations.to_a).to match_array(expected_result[premise_type].to_a)
      end
    end

    it 'caches the results' do
      expect(Rails.cache).to receive(:fetch)
        .with('footer_permutations', expires_in: 1.hour)
        .and_call_original

      described_class.fetch
    end
  end
end
