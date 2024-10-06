module SearchHelper
    class SearchHelperController < ApplicationController
      skip_before_action :authenticate_provider_user!
      skip_after_action :verify_authorized
        def index
          render template: 'search_helper/index'
        end

        def contact_form
          @search_contact = SearchContact.new
        end

        def submit_contact
          @search_contact = SearchContact.new(search_contact_params)
          if @search_contact.save
            render partial: 'success'
          else
            render partial: 'form_content', status: :unprocessable_entity
          end
        end

        private

        def search_contact_params
          params.require(:search_contact).permit(:company_name, :first_name, :last_name, :phone, :email, :number_of_workspaces, :office_type)
        end
    end
end