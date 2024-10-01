class ProviderUserMailer < ApplicationMailer
  default from: 'mikael@dweller.se'

  def magic_link(provider_user)
    Rails.logger.info "Generating magic link for user: #{provider_user.email}"
    @provider_user = provider_user
    @magic_token = @provider_user.generate_magic_token!
    Rails.logger.info "Magic token generated: #{@magic_token}"
    @magic_link_url = provider_portal_magic_link_url(token: @magic_token)
    Rails.logger.info "Magic link URL generated: #{@magic_link_url}"

    mail(to: @provider_user.email, subject: 'Your Magic Login Link')
  end
end