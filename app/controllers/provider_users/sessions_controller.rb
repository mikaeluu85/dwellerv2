# app/controllers/provider_users/sessions_controller.rb
module ProviderUsers
  class SessionsController < ActiveAdmin::Devise::SessionsController
    # Remove the inclusion of Pundit
    # include Pundit
    
    # Skip authorization as handled by ApplicationController
    skip_after_action :verify_authorized, only: [:new, :create]
  
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
  
    private
  
    # Remove the verify_authorized method
    # def verify_authorized
    #   authorize current_provider_user
    # end
  end
end