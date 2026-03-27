class ApiKey < ApplicationRecord
  has_secure_token :token
  belongs_to :user, optional: true

  enum :status, { active: 0, revoked: 1 }

  validates :name, presence: true

  def expired?
    expires_at.present? && expires_at < Time.current
  end

  def usable?
    active? && !expired?
  end
end
