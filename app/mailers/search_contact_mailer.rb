class SearchContactMailer < ApplicationMailer
  default to: 'mikael@dweller.se'

  def new_contact(search_contact)
    @search_contact = search_contact
    mail(
      subject: "Ny Kontorsförfrågan från #{@search_contact.first_name} #{@search_contact.last_name}"
    )
  end
end