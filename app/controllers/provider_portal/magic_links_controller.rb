module ProviderPortal
  class MagicLinksController < ApplicationController
    skip_before_action :authenticate_provider_user!, only: [:new, :create, :show]
    skip_after_action :verify_authorized, only: [:new, :create, :show]
    before_action :redirect_if_authenticated, only: [:new, :create]

    # Display the magic link request form
    def new
      @provider_user = ProviderUser.new
      render 'provider_portal/magic_links/new'
    end

    # Handle the magic link request
    def create
      Rails.logger.info "Starting create action"
      provider_user = ProviderUser.find_by(email: params[:provider_user][:email])
      Rails.logger.info "Provider user found: #{provider_user.present?}"

      if provider_user.present?
        Rails.logger.info "Attempting to send magic link email"
        ProviderUserMailer.magic_link(provider_user).deliver_now
        Rails.logger.info "Magic link email queued for delivery"
      end

      Rails.logger.info "Redirecting after create action"
      redirect_to provider_portal_new_magic_link_path, notice: 'Om det finns ett konto med denna e-postadress, har en magisk inloggningslänk skickats.'
    end

    # Authenticate the user via magic link
    def show
      token = params[:token]
      provider_user = ProviderUser.find_by(magic_token: token)

      if provider_user&.magic_token_valid?(token)
        sign_in_provider_user(provider_user)
        provider_user.consume_magic_token!
        session[:provider_user_id] = provider_user.id
        redirect_to provider_portal_dashboard_path, notice: 'Du är nu inloggad.'
      else
        redirect_to provider_portal_new_magic_link_path, alert: 'Den här länken är ogiltig eller har gått ut. Begär en ny länk.'
      end
    end

    private

    def redirect_if_authenticated
      redirect_to provider_portal_dashboard_path if provider_user_signed_in?
    end
  end
end