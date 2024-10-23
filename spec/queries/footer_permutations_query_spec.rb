# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FooterPermutationsQuery do
  describe '.fetch' do
    let!(:prioritized_location) { create(:location, prioritized: true) }
    let!(:non_prioritized_location) { create(:location, prioritized: false) }
    let!(:premise_type) { create(:premise_type) }
    
    let!(:prioritized_permutation) do
      create(:permutation, 
             premise_type: premise_type, 
             location: prioritized_location)
    end
    
    let!(:non_prioritized_permutation) do
      create(:permutation, 
             premise_type: premise_type, 
             location: non_prioritized_location)
    end

    it 'returns premise types with their prioritized permutations' do
      result = described_class.fetch
      
      expect(result.keys).to contain_exactly(premise_type)
      expect(result[premise_type]).to contain_exactly(prioritized_permutation)
    end

    it 'caches the results' do
      expect(Rails.cache).to receive(:fetch)
        .with('footer_permutations', expires_in: 1.hour)
        .and_call_original

      described_class.fetch
    end

    context 'when an error occurs' do
      before do
        allow(PremiseType).to receive(:with_prioritized_locations)
          .and_raise(StandardError, 'Test error')
      end

      it 'logs the error and returns an empty hash' do
        expect(Rails.logger).to receive(:error).with(/FooterPermutationsQuery failed:/)
        
        result = described_class.fetch
        expect(result).to eq({})
      end

      it 'raises the error in development environment' do
        allow(Rails.env).to receive(:development?).and_return(true)
        
        expect { described_class.fetch }.to raise_error(StandardError)
      end
    end
  end
end
