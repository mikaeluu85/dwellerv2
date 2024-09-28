ActiveAdmin.register ProviderUser do 
  menu parent: 'Customers', priority: 4
  permit_params :email, :encrypted_password, :role, :deleted_at

  scope :all, default: true
  scope :active, -> { where(deleted_at: nil) }
  scope :deleted, -> { where.not(deleted_at: nil) }

  index do
    selectable_column
    id_column
    column :email
    column :role
    actions
  end

  filter :email
  filter :role
  filter :deleted_at, as: :select, collection: [['Active', nil], ['Deleted', true]]

  form do |f|
    f.inputs do
      f.input :email
      f.input :role
      f.input :deleted_at
    end
    f.actions
  end
end
