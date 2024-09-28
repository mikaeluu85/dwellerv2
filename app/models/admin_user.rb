class AdminUser < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, 
         :recoverable, 
         :rememberable, 
         :validatable

  has_many :blog_posts, dependent: :destroy  # Ensure this association exists
  has_one_attached :avatar  # Add this line

  def self.ransackable_attributes(auth_object = nil)
    %w[email id created_at updated_at name avatar]
  end

  def self.ransackable_associations(auth_object = nil)
    ["blog_posts", "avatar_attachment", "avatar_blob"]  # Valid association
  end

  # Add this method
  def administrator?
    true  # Assuming all AdminUsers are administrators
  end

  def admin?
    true  # Or any logic to determine if the user is an admin
  end

  def to_sym
    :admin_user
  end

  def method_missing(method_name, *arguments, &block)
    if method_name.to_s == 'to_sym'
      Rails.logger.error "to_sym called on AdminUser instance"
      Rails.logger.error caller.join("\n")
      raise NoMethodError.new("undefined method `to_sym' for #{self.class}")
    else
      super
    end
  end
end
