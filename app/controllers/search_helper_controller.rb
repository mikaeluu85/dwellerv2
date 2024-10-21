class SearchHelperController < ApplicationController
  skip_after_action :verify_authorized
  skip_after_action :verify_policy_scoped

    def index
      render template: 'search_helper/index'
    end

    def contact_form
      @search_contact = SearchContact.new
      respond_to do |format|
        format.html { render layout: false }
        format.turbo_stream
      end
    end

    def submit_contact
      @search_contact = SearchContact.new(search_contact_params)
      if @search_contact.save
        begin
          SearchContactMailer.new_contact(@search_contact).deliver_later
        rescue StandardError => e
          Rails.logger.error "Failed to enqueue contact email: #{e.message}"
          # Optionally, handle the error (e.g., notify admin, retry, etc.)
        end
        respond_to do |format|
          format.turbo_stream do
            render turbo_stream: turbo_stream.update("modal-content", partial: "search_helper/success")
          end
        end
      else
        respond_to do |format|
          format.turbo_stream { render turbo_stream: turbo_stream.replace("modal-content", partial: "search_helper/form_content"), status: :unprocessable_entity }
        end
      end
    rescue Rack::Attack::Throttle => e
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.replace("modal-content", partial: "search_helper/rate_limit_error"), status: :too_many_requests }
      end
    end

    private

    def search_contact_params
      params.require(:search_contact).permit(
        :company_name,
        :first_name,
        :last_name,
        :phone,
        :email,
        :number_of_workspaces,
        :office_type,
        location_ids: []
      )
    end
end