# app/controllers/application_controller.rb
class ApplicationController < ActionController::Base
  include Pundit::Authorization
  include DeviseHelpers
  
  after_action :verify_authorized, except: :index, unless: :skip_authorization?
  after_action :verify_policy_scoped, only: :index, unless: :skip_authorization?
  
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
    devise_controller? || is_a?(ActiveAdmin::BaseController) || public_controller?
  end

  def public_controller?
    controller_name == 'office_calculator' || controller_name == 'pages' # Add any other public controllers here
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
    unless current_provider_user
      store_location_for(:provider_user, request.fullpath)
      redirect_to provider_portal_new_magic_link_path, notice: "Please log in to access this page."
    end
  end

  def current_provider_user
    @current_provider_user ||= ProviderUser.find_by(id: session[:provider_user_id]) if session[:provider_user_id]
  end

  helper_method :current_provider_user
end