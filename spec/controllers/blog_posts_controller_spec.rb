require 'rails_helper'

RSpec.describe BlogPostsController, type: :controller do
  let(:admin_user) { create(:admin_user) }
  let(:category) { create(:category) }
  let!(:visible_blog_post) { create(:blog_post, category: category, admin_user: admin_user, visible: true) }
  let!(:hidden_blog_post) { create(:blog_post, category: category, admin_user: admin_user, visible: false) }

  describe 'GET #index' do
    it 'returns a successful response' do
      get :index
      expect(response).to be_successful
    end

    it 'assigns only visible blog posts to @blog_posts' do
      get :index
      expect(assigns(:blog_posts)).to include(visible_blog_post)
      expect(assigns(:blog_posts)).not_to include(hidden_blog_post)
    end
  end

  describe 'GET #show' do
    context 'when the blog post is visible' do
      it 'returns a successful response' do
        get :show, params: { id: visible_blog_post.id }
        expect(response).to be_successful
      end

      it 'assigns the requested blog post to @blog_post' do
        get :show, params: { id: visible_blog_post.id }
        expect(assigns(:blog_post)).to eq(visible_blog_post)
      end

      it 'sets the correct meta tags' do
        get :show, params: { id: visible_blog_post.id }
        expect(controller.view_assigns['meta_tags'].meta_tags).to include(
          'title' => visible_blog_post.title,
          'description' => visible_blog_post.meta_description,
          'og' => hash_including(
            'title' => visible_blog_post.title,
            'description' => visible_blog_post.meta_description,
            'type' => 'article',
            'url' => request.original_url
          )
        )
      end
    end

    context 'when the blog post is not visible' do
      it 'redirects to the blog overview path' do
        get :show, params: { id: hidden_blog_post.id }
        expect(response).to redirect_to(blog_overview_path)
      end
    end
  end

  describe 'GET #category' do
    it 'returns a successful response' do
      get :category, params: { category_slug: category.slug }
      expect(response).to be_successful
    end

    it 'assigns the correct category to @category' do
      get :category, params: { category_slug: category.slug }
      expect(assigns(:category)).to eq(category)
    end

    it 'assigns only visible blog posts of the category to @blog_posts' do
      get :category, params: { category_slug: category.slug }
      expect(assigns(:blog_posts)).to include(visible_blog_post)
      expect(assigns(:blog_posts)).not_to include(hidden_blog_post)
    end
  end

  describe 'GET #feed' do
    it 'returns a successful response with RSS format' do
      get :feed, format: :rss
      expect(response).to be_successful
      expect(response.content_type).to start_with('application/rss+xml')
    end

    it 'assigns only visible blog posts to @blog_posts' do
      get :feed, format: :rss
      expect(assigns(:blog_posts)).to include(visible_blog_post)
      expect(assigns(:blog_posts)).not_to include(hidden_blog_post)
    end

    it 'renders the RSS feed without layout' do
      get :feed, format: :rss
      expect(response).to render_template('blog_posts/feed')
      expect(response).not_to render_template(layout: 'application')
    end
  end
end