ActiveAdmin.register Room do
  menu parent: 'Room solutions', priority: 8
  permit_params :listing_id, :size, :workspaces

  scope :all, default: true

  index do
    selectable_column
    id_column
    column :listing
    column :size
    column :workspaces
    actions
  end

  filter :listing
  filter :size
  filter :workspaces

  form do |f|
    f.inputs do
      f.input :listing
      f.input :size
      f.input :workspaces
    end
    f.actions
  end
end
