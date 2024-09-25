ActiveAdmin.register PremiseType do
  permit_params :name

  controller do
    def find_resource
      scoped_collection.find_by(id: params[:id]) || scoped_collection.friendly.find(params[:id])
    end
  end

  index do
    selectable_column
    id_column
    column :name
    column :slug
    actions
  end

  form do |f|
    f.inputs 'Premise Type Details' do
      f.input :name
    end
    f.actions
  end

  show do
    attributes_table do
      row :id
      row :name
      row :slug
      row :created_at
      row :updated_at
    end
  end

  filter :id # Ensure you can filter by ID
  filter :name
  filter :created_at
  filter :updated_at
end