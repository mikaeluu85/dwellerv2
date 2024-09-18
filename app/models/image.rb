class Image < ApplicationRecord
  belongs_to :blog_post
  has_one_attached :file

  validates :file, attached: true, content_type: ['image/png', 'image/jpg', 'image/jpeg', 'image/gif', 'image/svg+xml', 'image/webp'], size: { less_than: 5.megabytes }
  validates :alt_text, presence: true

  before_save :optimize_image

  private
  
  def optimize_image
    return unless file.attached?

    # Resize to a maximum width of 1600 while maintaining aspect ratio
    processed_image = file.variant(resize_to_limit: [1600, nil]).processed

    # Convert to WebP format and compress
    processed_image = processed_image.convert("webp").quality(80)

    processed_image
  end

end
