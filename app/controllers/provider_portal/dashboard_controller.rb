module ProviderPortal
    class DashboardController < ApplicationController
      before_action :authenticate_provider_user!
      layout 'provider_dashboard'
  
      def index
        @active_listings_with_offers_count = current_provider_user.provider.count_active_listings_with_active_offers
        # Add any necessary instance variables for your dashboard here
      end
    end
end