module BlogPostQueryable
  extend ActiveSupport::Concern

  class_methods do
    def cached_featured_posts
      Rails.cache.fetch("featured_blog_posts", expires_in: 1.hour) do
        Rails.logger.info "Cache miss: Loading featured blog posts"
        visible
          .includes(:category, :admin_user, featured_image_attachment: :blob)
          .order(created_at: :desc)
          .limit(6)
          .to_a
      end
    end

    def latest_update_timestamp
      maximum(:updated_at).try(:utc).try(:to_s, :number) || "no-posts"
    end
  end
end
