require 'rails_helper'

RSpec.describe BlogPostPolicy, type: :policy do
  subject { described_class.new(user, blog_post) }

  let(:blog_post) { create(:blog_post) }

  context 'being a visitor' do
    let(:user) { nil }

    it { is_expected.to permit_action(:index) }
    it { is_expected.to permit_action(:show) }
    it { is_expected.not_to permit_action(:create) }
    it { is_expected.not_to permit_action(:update) }
    it { is_expected.not_to permit_action(:destroy) }
  end

  context 'being an admin' do
    let(:user) { create(:admin_user) }

    it { is_expected.to permit_action(:index) }
    it { is_expected.to permit_action(:show) }
    it { is_expected.to permit_action(:create) }
    it { is_expected.to permit_action(:update) }
    it { is_expected.to permit_action(:destroy) }
  end

  describe 'Scope' do
    subject { BlogPostPolicy::Scope.new(user, BlogPost).resolve }

    let!(:published_post) { create(:blog_post, visible: true) }
    let!(:unpublished_post) { create(:blog_post, visible: false) }

    context 'for visitors' do
      let(:user) { nil }
      it { is_expected.to include(published_post) }
      it { is_expected.not_to include(unpublished_post) }
    end

    context 'for admin users' do
      let(:user) { create(:admin_user) }
      it { is_expected.to include(published_post, unpublished_post) }
    end
  end
end
