module ProviderPortal
    class DashboardController < ApplicationController
      layout 'provider_dashboard'
      before_action :authenticate_provider_user!
  
      def index
        # Add any necessary instance variables for your dashboard here
      end
    end
end