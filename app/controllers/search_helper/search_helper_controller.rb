module SearchHelper
    class SearchHelperController < ApplicationController
      skip_before_action :authenticate_provider_user!
      skip_after_action :verify_authorized
        def index
          render template: 'search_helper/index'
        end
    end
end