class AboutController < ApplicationController
    skip_before_action :authenticate_provider_user!
    skip_after_action :verify_authorized
  
    def index
    end
end 