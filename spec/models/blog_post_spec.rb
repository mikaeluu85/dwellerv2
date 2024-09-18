require 'rails_helper'

RSpec.describe BlogPost, type: :model do
  describe 'associations' do
    it { should belong_to(:admin_user) }
    it { should belong_to(:category) }
    it { should have_one_attached(:featured_image) }
    it { should have_many(:images).dependent(:destroy) }
    it { should accept_nested_attributes_for(:images).allow_destroy(true) }
  end

  describe 'validations' do
    subject { build(:blog_post) }

    it { should validate_presence_of(:title) }
    it { should validate_uniqueness_of(:title) }
    it { should validate_presence_of(:content) }
    it { should validate_presence_of(:category) }
    it { should validate_length_of(:meta_description).is_at_most(160) }
    it { should validate_length_of(:excerpt).is_at_most(300) }
  end

  describe 'ransackable attributes and associations' do
    it 'lists correct ransackable attributes' do
      expect(BlogPost.ransackable_attributes).to match_array([
        'title', 'content', 'excerpt', 'meta_description',
        'visible', 'top_story', 'created_at', 'updated_at'
      ])
    end

    it 'lists correct ransackable associations' do
      expect(BlogPost.ransackable_associations).to match_array([
        'admin_user', 'category', 'featured_image_attachment',
        'featured_image_blob', 'images'
      ])
    end
  end
end