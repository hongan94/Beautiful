class CacheService
  def self.fetch(key, ttl: 60)
    cached = REDIS.with { |r| r.get(key) }
    return JSON.parse(cached) if cached

    result = yield

    REDIS.with { |r| r.setex(key, ttl, result.to_json) }
    result
  end
end