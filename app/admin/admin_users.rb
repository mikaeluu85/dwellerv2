ActiveAdmin.register AdminUser do
  permit_params :email, :password, :password_confirmation, :avatar, :name

  index do
    selectable_column
    id_column
    column :email
    column :current_sign_in_at
    column :sign_in_count
    column :created_at
    column :avatar do |admin_user|
      if admin_user.avatar.attached?
        image_tag url_for(admin_user.avatar), size: "50x50"
      else
        "No Avatar"
      end
    end
    actions
  end

  filter :email
  filter :current_sign_in_at
  filter :sign_in_count
  filter :created_at

  form do |f|
    f.inputs 'Admin Details' do
      f.input :name
      f.input :email
      f.input :password
      f.input :password_confirmation
      f.input :avatar, as: :file
    end
    f.actions
  end

  show do
    attributes_table do
      row :email
      row :avatar do |admin_user|
        if admin_user.avatar.attached?
          image_tag url_for(admin_user.avatar), size: "100x100"
        else
          "No Avatar"
        end
      end
    end
    active_admin_comments
  end
end
