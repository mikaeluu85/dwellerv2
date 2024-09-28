module AdminUsers
  class SessionsController < ActiveAdmin::Devise::SessionsController
    skip_after_action :verify_authorized, only: [:new, :create]
  end
end
