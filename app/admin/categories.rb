ActiveAdmin.register Category do
  permit_params :name

  # Remove the complex filter and use a simpler one
  filter :name
  filter :created_at
  filter :updated_at

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

    # Override the find_resource method to use the primary key (ID)
    def find_resource
      Category.find_by(id: params[:id]) || Category.friendly.find(params[:id])
    end
  end
end