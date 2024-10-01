ActiveAdmin.register Listing do
  menu parent: 'Customers', priority: 1
  
  permit_params :name, :slug, :status, :source, :brand_id,
                :main_image, { gallery_images: [] },
                :area_description, :commuter_description,
                :conference_room_request_email, :cost_per_m2, :cost_per_user,
                :description, :description_en, :is_premium_listing,
                :number_of_meeting_rooms, :opened, :short_description,
                :short_description_en, :showing_message, :size,
                :surface_per_user, :url,
                address_attributes: [:id, :street, :city, :postal_code],
                amenity_ids: [],
                provider_user_ids: [],
                offers_attributes: [:id, :name, :description, :price, :_destroy]

  scope :all, default: true
  scope :active, -> { where(status: :active) }
  scope :pending, -> { where(status: :pending) }
  scope :inactive, -> { where(status: :inactive) }

  filter :status, as: :select, collection: Listing.statuses
  filter :name
  filter :source, as: :select, collection: Listing.sources
  filter :brand
  filter :created_at
  filter :provider_users_id, as: :select, collection: proc { ProviderUser.active.pluck(:email, :id) }, label: 'Provider User'
  filter :size, as: :numeric  # Changed back to just :size
  filter :cost_per_m2
  filter :cost_per_user
  filter :surface_per_user
  filter :number_of_meeting_rooms
  filter :opened
  filter :is_premium_listing

  index do
    selectable_column
    id_column
    column :name
    column :status
    column :source
    column :brand
    column :created_at
    column :offers do |listing|
      listing.offers.count
    end
    column :provider_users do |listing|
      listing.provider_users.count
    end
    column :is_premium_listing
    actions
  end

  show do
    attributes_table do
      row :id
      row :name
      row :slug
      row :status
      row :source
      row :brand
      row :area_description  # New row added
      row :commuter_description  # New row added
      row :main_image do |listing|
        image_tag listing.main_image.url if listing.main_image.attached?
      end
      row :gallery_images do |listing|
        ul do
          listing.gallery_images.each do |img|
            li do
              image_tag img.url, size: '100x100'
            end
          end
        end
      end
      row :address do |listing|
        listing.address&.full_address
      end
      row :amenities do |listing|
        listing.amenities.pluck(:name).join(", ")
      end
      row :provider_users do |listing|
        listing.provider_users.pluck(:email).join(", ")
      end
      row :offers do |listing|
        table_for listing.offers do
          column :name
          column :description
          column :price
        end
      end
      row :created_at
      row :updated_at
      row :size
      row :cost_per_m2
      row :cost_per_user
      row :surface_per_user
      row :description
      row :description_en
      row :number_of_meeting_rooms
      row :opened
      row :is_premium_listing
      row :conference_room_request_email
      row :short_description
      row :short_description_en
      row :url
      row :showing_message
    end
  end

  # Form view
  form do |f|
    f.inputs 'Listing Details' do
      f.input :name
      f.input :slug
      f.input :status, as: :select, collection: Listing.statuses.keys
      f.input :source, as: :select, collection: Listing.sources.keys
      f.input :brand
      f.input :main_image, as: :file
      f.input :gallery_images, as: :file, input_html: { multiple: true }
      f.input :area_description
      f.input :commuter_description
      f.input :conference_room_request_email
      f.input :cost_per_m2
      f.input :cost_per_user
      f.input :description
      f.input :description_en
      f.input :is_premium_listing
      f.input :number_of_meeting_rooms
      f.input :opened
      f.input :short_description
      f.input :short_description_en
      f.input :showing_message
      f.input :size
      f.input :surface_per_user
      f.input :url
    end

    f.inputs 'Address' do
      f.has_many :address, allow_destroy: true, new_record: true do |a|
        a.input :street
        a.input :city
        a.input :postal_code
      end
      
      f.inputs 'Amenities' do
        f.input :amenities, as: :check_boxes
      end
      
      f.inputs 'Provider Users' do
        f.input :provider_users, 
                as: :check_boxes
      end
      
      f.inputs 'Offers' do
        f.has_many :offers, allow_destroy: true, new_record: 'Add Offer' do |o|
          o.input :name
          o.input :description
          o.input :price
        end
      end
    end
    f.actions
  end

  collection_action :update_provider_users, method: :get do
    @brand = Brand.find(params[:brand_id])
    @provider_users = @brand.active_provider_users
    render layout: false
  end

  controller do
    def new
      @listing = Listing.new(brand_id: params[:brand_id])
      super
    end

    # Ensure that the find_resource method is not causing conflicts
    # def find_resource
    #   Listing.find_by!(slug: params[:id])
    # end
  end
end