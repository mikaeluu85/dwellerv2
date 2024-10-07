ActiveAdmin.register SearchContact do
menu parent: 'Leads', priority: 1
  permit_params :company_name, :first_name, :last_name, :phone, :email, :number_of_workspaces, :office_type, location_ids: []

  index do
    selectable_column
    id_column
    column :company_name
    column :first_name
    column :last_name
    column :email
    column :phone
    column :number_of_workspaces
    column :office_type
    column :locations do |search_contact|
      search_contact.locations.map(&:name).join(", ")
    end
    column :created_at
    actions
  end

  filter :company_name
  filter :first_name
  filter :last_name
  filter :email
  filter :phone
  filter :number_of_workspaces
  filter :office_type
  filter :locations
  filter :created_at

  form do |f|
    f.inputs do
      f.input :company_name
      f.input :first_name
      f.input :last_name
      f.input :email
      f.input :phone
      f.input :number_of_workspaces
      f.input :office_type
      f.input :locations, as: :select, multiple: true
    end
    f.actions
  end

  show do
    attributes_table do
      row :id
      row :company_name
      row :first_name
      row :last_name
      row :email
      row :phone
      row :number_of_workspaces
      row :office_type
      row :locations do |search_contact|
        search_contact.locations.map(&:name).join(", ")
      end
      row :created_at
      row :updated_at
    end
  end
end
