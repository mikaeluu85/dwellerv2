class OfficeCalculationMailer < ApplicationMailer
  default from: 'mikael@dweller.se'

  def submission_confirmation(office_calculation)
    @office_calculation = office_calculation
    @result_url = office_calculator_result_url(uuid: @office_calculation.uuid, email: @office_calculation.email)
    
    mail(
      to: @office_calculation.email,
      subject: "Din kontorskalkyl från Dweller"
    )
  end
end
