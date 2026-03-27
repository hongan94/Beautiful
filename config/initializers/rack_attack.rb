# Uncomment when installing `rack-attack` gem in Gemfile
# gem 'rack-attack'
# bundle install

if defined?(Rack::Attack)
  Rack::Attack.cache.store = ActiveSupport::Cache::MemoryStore.new

  # 1. Throttle ALL requests by IP (50 reqs / 10 seconds)
  Rack::Attack.throttle('req/ip', limit: 50, period: 10.seconds) do |req|
    req.ip unless req.path.start_with?('/assets')
  end

  # 2. Block Brute Force Login to Admin (5 attempts / 5 mins)
  Rack::Attack.throttle('admin-logins/ip', limit: 5, period: 5.minutes) do |req|
    if req.path == '/admin/sign_in' && req.post?
      req.ip
    end
  end

  # 3. Throttle API POST requests (Spam prevent)
  Rack::Attack.throttle('api-post/ip', limit: 10, period: 1.minute) do |req|
    if req.path.start_with?('/api/v1/') && req.post?
      req.ip
    end
  end

  # Custom Response for rate blocked users
  Rack::Attack.throttled_responder = lambda do |env|
    [ 429,  
      {'Content-Type' => 'application/json'},
      [{error: "Too Many Requests. Rate Limit Exceeded", retry_after: "Try again later."}.to_json]
    ]
  end
end
