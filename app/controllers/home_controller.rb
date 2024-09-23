   # app/controllers/home_controller.rb
   class HomeController < ApplicationController
    include BlogPostFetchable

    def index
      @facility_types = YAML.load_file(Rails.root.join('config', 'facility_types.yml'))
      @types = @facility_types  # Keep @types for backward compatibility
    end
  end