class SearchHelperController < ApplicationController
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
        render turbo_stream: turbo_stream.replace('modal-content', partial: 'success')
      else
        render turbo_stream: turbo_stream.replace('modal-content', partial: 'form_content')
      end
    end

    private

    def search_contact_params
      params.require(:search_contact).permit(:company_name, :first_name, :last_name, :phone, :email, :number_of_workspaces, :office_type, location_ids: [])
    end
end