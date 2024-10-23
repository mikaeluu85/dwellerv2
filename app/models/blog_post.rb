class BlogPost < ApplicationRecord
  include BlogPostQueryable  # Add this line
  extend FriendlyId
  friendly_id :title, use: :slugged

  before_validation :generate_slug

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

  # Add this scope
  scope :published, -> { where(visible: true) }
  scope :visible, -> { where(visible: true) }
  scope :recent, -> { order(created_at: :desc) }
  scope :by_category, ->(category_id) { where(category_id: category_id) if category_id.present? }
  scope :top_stories, -> { where(top_story: true) }

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
      slug
    ]
  end

  def should_generate_new_friendly_id?
    slug.blank? && new_record?
  end

  private

  def generate_slug
    self.slug = title.parameterize if slug.blank?
  end

  def self.find(input)
    if input.is_a?(Integer) || input.match?(/^\d+$/)
      super
    else
      friendly.find(input)
    end
  end
end
