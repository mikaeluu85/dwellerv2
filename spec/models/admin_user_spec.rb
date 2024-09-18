require 'rails_helper'

RSpec.describe AdminUser, type: :model do
  describe 'associations' do
    it { should have_many(:blog_posts).dependent(:destroy) }
  end

  describe 'validations' do
    subject { build(:admin_user) }

    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email).case_insensitive }
    it { should validate_presence_of(:password) }
    it { should validate_confirmation_of(:password) }
  end

  describe 'ransackable attributes and associations' do
    it 'lists correct ransackable attributes' do
      expect(AdminUser.ransackable_attributes).to match_array([
        'email', 'id', 'created_at', 'updated_at'
      ])
    end

    it 'lists correct ransackable associations' do
      expect(AdminUser.ransackable_associations).to match_array(['blog_posts'])
    end
  end
end