class BlogPost < ApplicationRecord
  belongs_to :admin_user
  belongs_to :category
  has_one_attached :featured_image
  has_many :images, dependent: :destroy

  accepts_nested_attributes_for :images, allow_destroy: true

  # Validations
  validates :title, :content, :category, presence: true
  validates :title, uniqueness: true
  validates :meta_description, length: { maximum: 160 }
  validates :excerpt, length: { maximum: 300 }

  def self.ransackable_associations(auth_object = nil)
    %w[
      admin_user
      category
      featured_image_attachment
      featured_image_blob
      images
    ]
  end

  def self.ransackable_attributes(auth_object = nil)
    %w[
      title
      content
      excerpt
      meta_description
      visible
      top_story
      created_at
      updated_at
    ]
  end
end
