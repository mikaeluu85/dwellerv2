ActiveAdmin.register AdminUser do
  menu parent: "Settings", priority: 5
  permit_params :email, :password, :password_confirmation, :name, :avatar

  index do
    selectable_column
    id_column
    column :name
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
    f.inputs "Admin Details" do
      f.input :name
      f.input :email
      if f.object.new_record?
        # Require password only for new records
        f.input :password
        f.input :password_confirmation
      else
        # Make password optional for existing records
        f.input :password,
                hint: "Leave blank if you don't want to change it",
                required: false,
                input_html: { autocomplete: "new-password" }
        f.input :password_confirmation,
                required: false,
                input_html: { autocomplete: "new-password" }
      end
      f.input :avatar, as: :file
    end
    f.actions
  end

  show do
    attributes_table do
      row :name
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

  controller do
    def update
      if params[:admin_user][:password].blank?
        params[:admin_user].delete(:password)
        params[:admin_user].delete(:password_confirmation)
      end

      password_update = params[:admin_user][:password].present?
      current_admin_user_id = current_admin_user.id

      # Handle the update directly
      if resource.update(permitted_params[:admin_user])
        if password_update && resource.id == current_admin_user_id
          sign_out(resource)
          # Force immediate redirect with return
          redirect_to("/admin_users/sign_in",
                    notice: "Password updated successfully. Please sign in with your new password.")
        else
          redirect_to admin_admin_user_path(resource),
                    notice: "Admin user was successfully updated."
        end
      else
        render :edit
      end
    end
  end
end
