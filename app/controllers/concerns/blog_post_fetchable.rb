module BlogPostFetchable
    extend ActiveSupport::Concern
  
    included do
      helper_method :fetch_blog_posts
    end
  
    private
  
    def fetch_blog_posts(category: nil)
      posts = BlogPost.visible.recent
      posts = posts.by_category(category.id) if category
      posts
    end
  end