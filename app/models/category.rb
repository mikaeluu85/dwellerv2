class Category < ApplicationRecord
    extend FriendlyId
    friendly_id :name, use: :slugged
  
    has_many :blog_posts, dependent: :destroy
  
    validates :name, presence: true, uniqueness: true
    validates :slug, presence: true, uniqueness: true

    def self.ransackable_attributes(auth_object = nil)
      ["created_at", "id", "name", "slug", "updated_at"]
    end

    def self.ransackable_associations(auth_object = nil)
      ["blog_posts"]
    end
end