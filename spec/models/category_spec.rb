require 'rails_helper'

RSpec.describe Category, type: :model do
  describe 'associations' do
    it { should have_many(:blog_posts).dependent(:destroy) }
  end

  describe 'validations' do
    subject { build(:category) }

    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name) }
    it { should validate_uniqueness_of(:slug) }

    context 'when friendly_id is disabled' do
      before do
        allow_any_instance_of(Category).to receive(:should_generate_new_friendly_id?).and_return(false)
      end

      it 'validates presence of slug' do
        category = build(:category, slug: nil)
        expect(category).not_to be_valid
        expect(category.errors[:slug]).to include("can't be blank")
      end
    end
  end
end