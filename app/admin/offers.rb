ActiveAdmin.register Offer do
  menu parent: 'Customers', priority: 3
  permit_params :listing_id, :name, :description, :description_en, :price, :desk_type, :nb_days, :personal, :area, :max_seats, :min_seats, :terms, :status, :type, :category, :deleted_at

  scope :all, default: true
  scope :active, -> { where(deleted_at: nil) }
  scope :deleted, -> { where.not(deleted_at: nil) }

  index do
    selectable_column
    id_column
    column :name
    column :listing
    column :price
    column :desk_type
    column :status
    column :type
    column :category
    actions
  end

  filter :name
  filter :provider_user
  filter :valid_from
  filter :valid_until
  filter :deleted_at, as: :select, collection: [['Active', nil], ['Deleted', true]]

  form do |f|
    f.inputs do
      f.input :listing
      f.input :name
      f.input :description
      f.input :description_en
      f.input :price
      f.input :desk_type
      f.input :nb_days
      f.input :personal
      f.input :area
      f.input :max_seats
      f.input :min_seats
      f.input :terms
      f.input :status, as: :select, collection: Offer.statuses
      f.input :type, as: :select, collection: Offer.types
      f.input :category, as: :select, collection: Offer.categories
      f.input :deleted_at
    end
    f.actions
  end
end
