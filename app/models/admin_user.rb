class AdminUser < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, 
         :recoverable, 
         :rememberable, 
         :validatable

  has_many :blog_posts, dependent: :destroy  # Ensure this association exists

  def self.ransackable_attributes(auth_object = nil)
    %w[email id created_at updated_at]
  end

  def self.ransackable_associations(auth_object = nil)
    ["blog_posts"]  # Valid association
  end
end
