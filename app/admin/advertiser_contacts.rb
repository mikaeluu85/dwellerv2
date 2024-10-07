ActiveAdmin.register AdvertiserContact do
menu parent: 'Leads', priority: 1
  permit_params :company_name, :org_number, :first_name, :last_name, :phone, :email

  # Customize the index page
  index do
    selectable_column
    id_column
    column :company_name
    column :org_number
    column :first_name
    column :last_name
    column :phone
    column :email
    column :created_at
    actions
  end

  # Customize the filter options
  filter :company_name
  filter :org_number
  filter :first_name
  filter :last_name
  filter :phone
  filter :email
  filter :created_at

  # Customize the form
  form do |f|
    f.inputs 'Advertiser Contact Details' do
      f.input :company_name
      f.input :org_number
      f.input :first_name
      f.input :last_name
      f.input :phone
      f.input :email
    end
    f.actions
  end

  # Customize the show page
  show do
    attributes_table do
      row :id
      row :company_name
      row :org_number
      row :first_name
      row :last_name
      row :phone
      row :email
      row :created_at
      row :updated_at
    end
  end
end
