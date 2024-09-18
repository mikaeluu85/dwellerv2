class Category < ApplicationRecord
    extend FriendlyId
    friendly_id :name, use: :slugged
  
    has_many :blog_posts, dependent: :destroy
  
    validates :name, presence: true, uniqueness: true
    validates :slug, uniqueness: true
  end