# app/controllers/application_controller.rb
class ApplicationController < ActionController::Base
  include Pundit::Authorization
  
  before_action :authenticate_provider_user!
  after_action :verify_authorized, except: :index, unless: :skip_authorization?
  
  before_action :set_locale
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  
  private
  
  def set_locale
    I18n.locale = :sv
  end

  def user_not_authorized
    flash[:alert] = "You are not authorized to perform this action."
    redirect_to(request.referrer || root_path)
  end

  def skip_authorization?
    devise_controller? || active_admin_resource? || active_storage_controller?
  end

  def active_admin_resource?
    self.class.ancestors.include?(ActiveAdmin::BaseController) ||
      self.class.name.start_with?("ActiveAdmin::")
  end

  def active_storage_controller?
    self.class < ActiveStorage::BaseController
  end

  def pundit_user
    current_admin_user || current_provider_user
  end

  def authenticate_provider_user!
    Rails.logger.info "Authenticating provider user"
    unless current_provider_user
      Rails.logger.info "No current provider user, redirecting to magic link path"
      flash[:alert] = "You need to sign in or sign up before continuing."
      redirect_to provider.new_magic_link_path
    end
    Rails.logger.info "Provider user authenticated"
  end

  def current_provider_user
    @current_provider_user ||= ProviderUser.find_by(id: session[:provider_user_id])
  end

  helper_method :current_provider_user
end