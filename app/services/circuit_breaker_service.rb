class CircuitBreakerService
  BLOCK_TIME = 30

  def self.call(url)
    key = "circuit:#{url}"

    blocked = REDIS.with { |r| r.get(key) }
    raise "Service Down" if blocked

    begin
      response = Faraday.get(url)
      JSON.parse(response.body)
    rescue
      REDIS.with { |r| r.setex(key, BLOCK_TIME, "down") }
      raise "Service temporarily unavailable"
    end
  end
end