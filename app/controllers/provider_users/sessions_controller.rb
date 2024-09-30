# app/controllers/provider_users/sessions_controller.rb
module ProviderUsers
  class SessionsController < Devise::SessionsController
    # Remove the inclusion of Pundit
    # include Pundit
    
    # Skip authorization as handled by ApplicationController
    skip_after_action :verify_authorized, only: [:new, :create, :destroy]
  
    # GET /provider_users/sign_in
    def new
      super
    end
  
    # POST /provider_users/sign_in
    def create
      super
      # Remove the explicit authorization call
      # verify_authorized
    end

    # Override the destroy action to ensure proper logout
    def destroy
      sign_out_provider_user
      super  # Calls Devise's built-in destroy action
    end
  
    private
  
    def respond_to_on_destroy
      respond_to do |format|
        format.all { redirect_to after_sign_out_path_for(resource_name), notice: 'Logged out successfully.' }
      end
    end
  
    def after_sign_out_path_for(resource_or_scope)
      provider_portal_new_magic_link_path
    end
  end
end