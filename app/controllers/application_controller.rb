# app/controllers/application_controller.rb
class ApplicationController < ActionController::Base
  include Pundit::Authorization
  
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
    current_admin_user
  end
end