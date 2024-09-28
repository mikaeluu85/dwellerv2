if Rails.env.production? || Rails.env.staging?
    Rails.application.config.action_controller.raise_on_missing_callback_actions = false
  else
    Rails.application.config.action_controller.raise_on_missing_callback_actions = false
  end