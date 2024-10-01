class Provider < ApplicationRecord
    acts_as_paranoid
    has_many :brands
    has_many :provider_users
    has_many :listings, through: :brands
    has_one_attached :logo

    validates :name, presence: true
    validates :ovid, :woid, uniqueness: true, allow_blank: true
    validates :postal_code, format: { with: /\A\d{5}\z/, message: "should be 5 digits" }, allow_blank: true
    validates :organizational_number, format: { with: /\A\d{6}-\d{4}\z/, message: "should be in the format XXXXXX-XXXX" }, allow_blank: true
    validates :invoice_email, :contact_email, format: { with: URI::MailTo::EMAIL_REGEXP }, allow_blank: true
    validates :website, format: { with: URI::DEFAULT_PARSER.make_regexp(%w[http https]), message: "must be a valid URL" }, allow_blank: true

    scope :active, -> { where(deleted_at: nil) }
    scope :deleted, -> { where.not(deleted_at: nil) }

    def self.ransackable_attributes(auth_object = nil)
        ["created_at", "deleted_at", "id", "name", "updated_at", "ovid", "postal_code", "city", "organizational_number", "street", "invoice_email", "woid", "website", "contact_email"]
    end

    def self.ransackable_associations(auth_object = nil)
        ["brands", "provider_users", "logo_attachment", "logo_blob"]
    end

    def count_active_listings_with_active_offers
        listings.active.joins(:offers).where(offers: { status: :active }).distinct.count
    end
end