require 'rails_helper'

RSpec.describe BlogPostPolicy, type: :policy do
  subject { described_class }

  let(:user) { create(:user) }
  let(:admin_user) { create(:admin_user) }
  let(:blog_post) { create(:blog_post) }

  permissions ".scope" do
    context "when user is admin" do
      subject { Pundit.policy_scope(admin_user, BlogPost) }

      it "shows all blog posts" do
        published_post = create(:blog_post, published: true)
        unpublished_post = create(:blog_post, published: false)
        expect(subject).to include(published_post, unpublished_post)
      end
    end

    context "when user is regular user" do
      subject { Pundit.policy_scope(user, BlogPost) }

      it "shows only published blog posts" do
        published_post = create(:blog_post, published: true)
        unpublished_post = create(:blog_post, published: false)
        expect(subject).to include(published_post)
        expect(subject).not_to include(unpublished_post)
      end
    end
  end

  permissions :index? do
    it "allows access to anyone" do
      expect(subject).to permit(user, BlogPost)
    end
  end

  permissions :show? do
    it "allows access to anyone" do
      expect(subject).to permit(user, blog_post)
    end
  end
end
