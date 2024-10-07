module ProviderPortal
  class MagicLinksController < ApplicationController
    before_action :redirect_if_authenticated, only: [:new, :create]
    skip_after_action :verify_authorized, only: [:new, :create, :show]

    # Display the magic link request form
    def new
      @provider_user = ProviderUser.new
    end

    # Handle the magic link request
    def create
      @provider_user = ProviderUser.find_by(email: params[:provider_user][:email])
      if @provider_user
        ProviderUserMailer.magic_link(@provider_user).deliver_now
        redirect_to provider_portal_new_magic_link_path, notice: 'Magic link sent to your email.'
      else
        flash.now[:alert] = 'Email not found.'
        render :new
      end
    end

    # Authenticate the user via magic link
    def show
      token = params[:token]
      provider_user = ProviderUser.find_by(magic_token: token)

      if provider_user&.magic_token_valid?(token)
        sign_in_provider_user(provider_user)
        provider_user.consume_magic_token!
        redirect_to after_sign_in_path_for(provider_user), notice: 'You are now logged in.'
      else
        redirect_to provider_portal_new_magic_link_path, alert: 'This link is invalid or has expired. Please request a new one.'
      end
    end

    private

    def redirect_if_authenticated
      redirect_to provider_portal_dashboard_path if current_provider_user
    end

    def after_sign_in_path_for(provider_user)
      stored_location_for(:provider_user) || provider_portal_dashboard_path
    end
  end
end