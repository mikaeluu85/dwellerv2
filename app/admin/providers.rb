ActiveAdmin.register Provider do
  menu parent: 'Customers', priority: 2
  permit_params :name, :description, :ovid, :postal_code, :city, :invoice_notes, :organizational_number, :street, :invoice_email, :woid, :website, :contact_email, :deleted_at, provider_user_ids: [] # Allow multiple provider_user_ids

  scope :all, default: true
  scope :active, -> { where(deleted_at: nil) }
  scope :deleted, -> { where.not(deleted_at: nil) }

  index do
    selectable_column
    id_column
    column :name
    column :city
    column :ovid
    column :woid
    actions
  end

  filter :name
  filter :city
  filter :ovid
  filter :woid
  filter :deleted_at, as: :select, collection: [['Active', nil], ['Deleted', true]]

  form do |f|
    f.inputs do
      f.input :name
      f.input :description
      f.input :ovid
      f.input :postal_code
      f.input :city
      f.input :invoice_notes
      f.input :organizational_number
      f.input :street
      f.input :invoice_email
      f.input :woid
      f.input :website
      f.input :contact_email
      f.input :provider_users, as: :select, collection: ProviderUser.all.collect { |pu| [pu.email, pu.id] }, multiple: true # Multi-select for provider users
    end
    f.actions
  end

  show do
    attributes_table do
      row :name
      row :description
      row :ovid
      row :postal_code
      row :city
      row :invoice_notes
      row :organizational_number
      row :street
      row :invoice_email
      row :woid
      row :website
      row :contact_email
      row :provider_users do |provider|
        provider.provider_users.map(&:email).join(", ") # Display associated provider users
      end
    end
    active_admin_comments
  end
end
