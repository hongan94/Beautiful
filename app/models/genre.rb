class Genre < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged

  enum :status, {
    active: 1,
    inactive: 0
  }, default: 1

  validates :name, presence: true
end
