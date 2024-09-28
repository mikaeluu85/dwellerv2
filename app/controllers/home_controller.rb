   # app/controllers/home_controller.rb
   class HomeController < ApplicationController

    skip_after_action :verify_authorized, only: [:index, :show]

    def index
      @facility_types = YAML.load_file(Rails.root.join('config', 'facility_types.yml'))
      @types = @facility_types  # Keep @types for backward compatibility
    end
  end