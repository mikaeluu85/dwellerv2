ActiveAdmin.register Listing do
  menu parent: 'Customers', priority: 1
  permit_params :brand_id, :size, :cost_per_m2, :cost_per_user, :surface_per_user, :description, :description_en, :number_of_meeting_rooms, :opened, :is_premium_listing, :conference_room_request_email, :name, :short_description, :short_description_en, :url, :showing_message, :status, :source, :deleted_at

  # Scopes for active and deleted listings
  scope :all, default: true
  scope :active, -> { where(deleted_at: nil) }
  scope :deleted, -> { where.not(deleted_at: nil) }

  index do
    selectable_column
    id_column
    column :name
    column :brand
    column :size
    column :cost_per_m2
    actions
  end

  filter :name
  filter :brand
  filter :status
  filter :deleted_at, as: :select, collection: [['Active', nil], ['Deleted', true]]

  form do |f|
    f.inputs do
      f.input :brand
      f.input :size
      f.input :cost_per_m2
      f.input :cost_per_user
      f.input :surface_per_user
      f.input :description
      f.input :description_en
      f.input :number_of_meeting_rooms
      f.input :opened
      f.input :is_premium_listing
      f.input :conference_room_request_email
      f.input :short_description
      f.input :short_description_en
      f.input :url
      f.input :showing_message
      f.input :status
      f.input :source
      f.input :deleted_at
    end
    f.actions
  end
end