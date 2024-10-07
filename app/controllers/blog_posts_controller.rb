class BlogPostsController < ApplicationController
  include MarkdownHelper

  def index
    @blog_posts = BlogPost.visible.recent.page(params[:page]).per(6)
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