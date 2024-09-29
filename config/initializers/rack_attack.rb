class Rack::Attack
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
  
    # Customize the response for throttled requests
    self.throttled_response = lambda do |env|
      [429, { 'Content-Type' => 'application/json' }, [{ error: "Du har begärt en magisk länk för inloggning flera gånger. Vänligen försök igen senare." }.to_json]]
    end
  end