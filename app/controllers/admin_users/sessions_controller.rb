module AdminUsers
  class SessionsController < Devise::SessionsController
    # No need to override sign_in; use Devise's implementation
    skip_after_action :verify_authorized, only: [:new, :create, :destroy]

    def destroy
      super
    end
  end
end
