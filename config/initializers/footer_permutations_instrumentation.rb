ActiveSupport::Notifications.subscribe('footer_permutations.fetch') do |*args|
  event = ActiveSupport::Notifications::Event.new(*args)
  
  Rails.logger.info(
    "FooterPermutations fetched in #{event.duration.round(2)}ms. " \
    "Cache #{event.payload[:cache_hit] ? 'HIT' : 'MISS'}."
  )
end
