class ContactMailer < ApplicationMailer
  def new_advertiser_contact(advertiser_contact)
    @advertiser_contact = advertiser_contact
    mail(to: 'mikael@dweller.se', subject: 'New Advertiser Contact Form Submission')
  end
end
