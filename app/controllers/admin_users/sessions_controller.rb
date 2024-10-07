module AdminUsers
  class SessionsController < Devise::SessionsController
    layout 'active_admin_logged_out'
    # No need to override sign_in; use Devise's implementation
    skip_after_action :verify_authorized, only: [:new, :create, :destroy]

    # Include Active Admin view helpers
    helper ActiveAdmin::ViewHelpers

    def after_sign_in_path_for(resource)
      admin_dashboard_path
    end

    # Define flash_messages method
    helper_method :flash_messages
    def flash_messages
      flash.to_hash.slice("error", "warning", "notice")
    end

    def destroy
      super
    end
  end
end
