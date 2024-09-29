class ProviderUser < ApplicationRecord
  acts_as_paranoid
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  scope :active, -> { where(deleted_at: nil) }
  scope :deleted, -> { where.not(deleted_at: nil) }

  enum role: [:editor, :administrator]

  belongs_to :provider
  has_many :listing_users
  has_many :listings, through: :listing_users
  has_many :offers

  # Virtual attribute for login email
  attr_accessor :login_email

  # Validations
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :mobile_phone, format: { with: /\A\+?[\d\s]+\z/, message: "must be a valid phone number" }, allow_blank: true
  validates :password, presence: true, on: :create
  validates :password_confirmation, presence: true, on: :create

  # Scopes
  scope :active, -> { where(deleted_at: nil) }
  scope :deleted, -> { where.not(deleted_at: nil) }

  # Magic Link Token Management

  # Generate a magic link token
  def generate_magic_token!
    magic_token = SecureRandom.hex(10)
    magic_token_expires_at = 15.minutes.from_now
    update!(magic_token: magic_token, magic_token_expires_at: magic_token_expires_at, magic_token_consumed_at: nil)
    magic_token
  end

  # Consume a magic link token
  def consume_magic_token!
    update!(magic_token_consumed_at: Time.current, magic_token: nil, magic_token_expires_at: nil)
  end

  # Validate the magic token
  def magic_token_valid?(token)
    magic_token == token && magic_token_expires_at > Time.current && magic_token_consumed_at.nil?
  end

  # Full name helper
  def full_name
    "#{first_name} #{last_name}"
  end

  # Ransackable attributes for searching/filtering
  def self.ransackable_attributes(auth_object = nil)
    [
      "created_at", "deleted_at", "id", "email", "encrypted_password",
      "reset_password_token", "reset_password_sent_at", "remember_created_at",
      "role", "provider_id", "updated_at", "first_name", "last_name",
      "mobile_phone", "magic_token", "magic_token_expires_at", "magic_token_consumed_at"
    ]
  end

  def self.ransackable_associations(auth_object = nil)
    ["provider", "listings", "offers"]
  end
end