class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_one_attached :avatar_url

  enum :role, { admin: 0, user: 1 }, default: :user
  enum :gender, { male: 0, female: 1, other: 2 }, default: :male
  enum :status, { active: 0, inactive: 1 }, default: :active

  normalizes :email_address, with: ->(e) { e.strip.downcase }
  validates :email_address, :phone_number, :first_name, :last_name, presence: true
  
  def name
    "#{first_name} #{last_name}"
  end
end
