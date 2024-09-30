module DeviseHelpers
  extend ActiveSupport::Concern

  included do
    helper_method :provider_user_signed_in?
  end

  def provider_user_signed_in?
    !!current_provider_user
  end

  def current_provider_user
    @current_provider_user ||= ProviderUser.find_by(id: session[:provider_user_id]) if session[:provider_user_id]
  end

  def sign_in_provider_user(provider_user)
    session[:provider_user_id] = provider_user.id
  end

  def sign_out_provider_user
    session.delete(:provider_user_id)
    @current_provider_user = nil
  end
end
