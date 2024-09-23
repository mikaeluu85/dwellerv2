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
    it { should validate_presence_of(:content) }
    it { should validate_presence_of(:category) }
    it { should validate_uniqueness_of(:title) }
    it { should validate_length_of(:meta_description).is_at_most(160) }
    it { should validate_length_of(:excerpt).is_at_most(300) }
  end

  describe 'friendly_id' do
    let(:blog_post) { create(:blog_post, title: 'Test Blog Post') }

    it 'generates a slug from the title' do
      expect(blog_post.slug).to eq('test-blog-post')
    end

    it 'finds the blog post by slug' do
      expect(BlogPost.friendly.find(blog_post.slug)).to eq(blog_post)
    end

    it 'does not regenerate slug when title changes' do
      original_slug = blog_post.slug
      blog_post.update(title: 'Updated Test Blog Post')
      expect(blog_post.slug).to eq(original_slug)
    end
  end

  describe 'scopes' do
    it 'returns visible blog posts' do
      visible_post = create(:blog_post, visible: true)
      hidden_post = create(:blog_post, visible: false)
      expect(BlogPost.visible).to include(visible_post)
      expect(BlogPost.visible).not_to include(hidden_post)
    end

    it 'returns recent blog posts' do
      old_post = create(:blog_post, created_at: 1.week.ago)
      new_post = create(:blog_post, created_at: 1.day.ago)
      expect(BlogPost.recent.first).to eq(new_post)
    end

    it 'returns top stories' do
      top_story = create(:blog_post, top_story: true)
      regular_post = create(:blog_post, top_story: false)
      expect(BlogPost.top_stories).to include(top_story)
      expect(BlogPost.top_stories).not_to include(regular_post)
    end
  end

  describe 'ransackable attributes and associations' do
    it 'lists correct ransackable attributes' do
      expect(BlogPost.ransackable_attributes).to match_array([
        'title', 'content', 'excerpt', 'meta_description',
        'visible', 'top_story', 'created_at', 'updated_at', 'slug'  # Add 'slug' here
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