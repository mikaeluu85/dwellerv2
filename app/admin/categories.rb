ActiveAdmin.register Category do
  permit_params :name

  index do
    selectable_column
    id_column
    column :name
    column :slug
    actions
  end

  form do |f|
    f.inputs 'Category Details' do
      f.input :name
    end
    f.actions
  end

  controller do
    include Rails.application.routes.url_helpers
    include ActiveStorage::SetCurrent
  end

end