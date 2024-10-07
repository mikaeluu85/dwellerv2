class AdvertisersController < ApplicationController
  skip_after_action :verify_authorized, only: [:index, :contact_form]

  def index
  end

  def contact_form
    @advertiser_contact = AdvertiserContact.new
    respond_to do |format|
      format.html { render layout: false }
      format.turbo_stream
    end
  end

  def submit_contact
    @advertiser_contact = AdvertiserContact.new(advertiser_contact_params)

    if @advertiser_contact.save
      ContactMailer.new_advertiser_contact(@advertiser_contact).deliver_later
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.update("modal-content", partial: "advertisers/success")
        end
      end
    else
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.replace("modal-content", partial: "form_content") }
      end
    end
  end

  private

  def advertiser_contact_params
    params.require(:advertiser_contact).permit(:company_name, :org_number, :first_name, :last_name, :phone, :email)
  end
end
