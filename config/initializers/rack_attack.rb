class Rack::Attack
    # Use Redis for storing rate limit data (recommended for production)
    # Rack::Attack.cache.store = Redis.new

    # Or use Rails.cache (memory store, suitable for development)
    Rack::Attack.cache.store = ActiveSupport::Cache::MemoryStore.new

    # Throttle by IP address - 5 requests per minute
    throttle('limit_magic_links/ip', limit: 1, period: 60) do |req|
      if req.path == '/provider/magic-login' && req.post?
        req.ip
      end
    end
  
    # Throttle by email - 5 requests per hour
    throttle('limit_magic_links/email', limit: 1, period: 1.hour) do |req|
      if req.path == '/provider/magic-login' && req.post? && req.params['provider_user'] && req.params['provider_user']['email'].present?
        req.params['provider_user']['email'].downcase
      end
    end

    # Throttle POST requests to /search_helper/submit_contact
    throttle('search_helper/submit_contact', limit: 5, period: 1.hour) do |req|
      if req.path == '/search_helper/submit_contact' && req.post?
          req.ip
      end
    end

    # Throttle POST requests to /advertisers/submit_contact
    throttle('limit_advertiser_contact/ip', limit: 5, period: 60) do |req|
      if req.path == '/advertisers/submit_contact' && req.post?
        req.ip
      end
    end

    # Throttle POST requests to /advertisers/submit_contact by email
    throttle('limit_advertiser_contact/email', limit: 3, period: 1.hour) do |req|
      if req.path == '/advertisers/submit_contact' && req.post? && req.params['advertiser_contact'] && req.params['advertiser_contact']['email'].present?
        req.params['advertiser_contact']['email'].downcase
      end
    end

    # Use the new throttled_responder with your custom error messages
    self.throttled_responder = lambda do |request|
      error_message = case request.path
                     when '/provider/magic-login'
                       "Du har begärt en magisk länk för inloggning flera gånger. Vänligen försök igen senare."
                     when '/search_helper/submit_contact'
                       "Du har överskridit antalet tillåtna förfrågningar. Vänligen försök igen senare."
                     when '/advertisers/submit_contact'
                       "Du har överskridit antalet tillåtna förfrågningar för kontaktformuläret. Vänligen försök igen senare."
                     else
                       "Något gick fel, vänligen försök igen senare."
                     end
      
      [429, { 'Content-Type' => 'application/json' }, [{ error: error_message }.to_json]]
    end
end
