class BlogPostsController < ApplicationController
  include MarkdownHelper
  skip_after_action :verify_policy_scoped, only: :index

  def index
    @category = Category.find_by(slug: params[:category_slug]) if params[:category_slug]
    
    # Start with the policy scope, passing current_user or nil
    base_scope = policy_scope(BlogPost)
    
    # Build the query using recent instead of ordered
    @blog_posts = base_scope
      .then { |scope| @category ? scope.where(category: @category) : scope }
      .recent
      .page(params[:page])
      .per(12)

    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  def show
    @blog_post = BlogPost.friendly.find(params[:slug])
    authorize @blog_post  # Explicitly authorize the blog post
    redirect_to blog_overview_path unless @blog_post.visible?

    set_meta_tags title: @blog_post.title,
                  description: @blog_post.meta_description,
                  og: {
                    title: @blog_post.title,
                    description: @blog_post.meta_description,
                    type: 'article',
                    url: request.original_url,
                    image: @blog_post.featured_image.attached? ? url_for(@blog_post.featured_image) : nil
                  }
  end

  def category
    @category = Category.friendly.find(params[:category_slug])
    @blog_posts = @category.blog_posts.where(visible: true).order(created_at: :desc).page(params[:page]).per(6)
  end

  def feed
    @blog_posts = BlogPost.where(visible: true).order(created_at: :desc)
    respond_to do |format|
      format.rss { render layout: false }  # Renders feed.rss.builder
    end
  end

  private

  def fetch_blog_posts(category: nil)
    posts = BlogPost.visible.recent
    posts = posts.by_category(category.id) if category
    posts
  end
end
