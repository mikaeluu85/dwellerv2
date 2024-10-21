class CleanOldCalculatorCacheJob < ApplicationJob
  queue_as :default

  def perform
    Rails.cache.delete_matched("office_calculator_*")
  end
end
