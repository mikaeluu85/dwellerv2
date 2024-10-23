module AuthHelpers
  def login_admin
    admin = create(:admin_user)
    sign_in admin
    admin
  end

  def login_provider_user
    user = create(:provider_user)
    sign_in user
    user
  end
end

RSpec.configure do |config|
  config.include AuthHelpers, type: :request
  config.include AuthHelpers, type: :controller
end
