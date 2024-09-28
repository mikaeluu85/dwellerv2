ActiveAdmin.register ExternalListing do
  menu parent: 'Customers', priority: 6
  permit_params :deleted_at, :external_id, :listing_id, :source_url

  scope :all, default: true
  scope :active, -> { where(deleted_at: nil) }
  scope :deleted, -> { where.not(deleted_at: nil) }

  index do
    selectable_column
    id_column
    column :external_id
    column :listing_id
    column :source_url
    actions
  end

  filter :external_id
  filter :listing_id
  filter :source_url
  filter :deleted_at, as: :select, collection: [['Active', nil], ['Deleted', true]]

  form do |f|
    f.inputs do
      f.input :deleted_at
      f.input :external_id
      f.input :listing_id
      f.input :source_url
    end
    f.actions
  end
end