class RateLimiter
  LIMIT = 1000
  WINDOW = 60 # seconds

  def initialize(app)
    @app = app
  end

  def call(env)
    request = Rack::Request.new(env)
    key = "rate_limit:#{request.ip}"

    count = REDIS.with { |r| r.incr(key) }
    REDIS.with { |r| r.expire(key, WINDOW) } if count == 1

    if count > LIMIT
      return [
        429,
        { "Content-Type" => "application/json" },
        [{ error: "Too Many Requests" }.to_json]
      ]
    end

    @app.call(env)
  end
end