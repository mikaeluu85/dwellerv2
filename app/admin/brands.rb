ActiveAdmin.register Brand do
  menu parent: 'Customers', priority: 1
  permit_params :name, :provider_id, :extended_description, :active, :header_image, :logo, :slug, :is_featured, :description, :deleted_at

  scope :all, default: true
  scope :active, -> { where(deleted_at: nil, active: true) }
  scope :deleted, -> { where.not(deleted_at: nil) }

  index do
    selectable_column
    id_column
    column :name
    column :provider
    column :active
    column :is_featured
    actions
  end

  filter :name
  filter :provider
  filter :active
  filter :is_featured
  filter :deleted_at, as: :select, collection: [['Active', nil], ['Deleted', true]]

  form do |f|
    f.inputs do
      f.input :name
      f.input :provider
      f.input :description # Keep the description field
      f.input :extended_description
      f.input :active
      f.input :header_image, as: :file
      f.input :logo, as: :file
      f.input :is_featured
      f.input :slug
      f.input :deleted_at
    end
    f.actions
  end

  controller do
    def find_resource
      scoped_collection.find_by(id: params[:id]) || scoped_collection.friendly.find(params[:id])
    end
  end
end
