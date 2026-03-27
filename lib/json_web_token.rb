class JsonWebToken
  SECRET = "super_secret_key"

  def self.encode(payload)
    JWT.encode(payload, SECRET)
  end

  def self.decode(token)
    JWT.decode(token, SECRET)[0]
  rescue
    nil
  end
end