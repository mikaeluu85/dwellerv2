ActiveAdmin.register Amenity do
  menu parent: 'Settings', priority: 1
  permit_params :name, :description, :deleted_at

  scope :all, default: true
  scope :active, -> { where(deleted_at: nil) }
  scope :deleted, -> { where.not(deleted_at: nil) }

  index do
    selectable_column
    id_column
    column :name
    actions
  end

  filter :name
  filter :deleted_at, as: :select, collection: [['Active', nil], ['Deleted', true]]

  form do |f|
    f.inputs do
      f.input :name
      f.input :deleted_at
    end
    f.actions
  end
end
