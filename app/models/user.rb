class User < ApplicationRecord
  # searchkick
  extend Pagy::Searchkick

  has_secure_password
  has_many :sessions, dependent: :destroy
  has_one_attached :avatar_url

  belongs_to :user_group, optional: true

  include Queryable
  
  enum :role, { admin: 0, user: 1 }, default: :user
  enum :gender, { male: 0, female: 1, other: 2 }, default: :male
  enum :status, { active: 0, inactive: 1 }, default: :active

  self.searchable_columns = [:first_name, :last_name, :email_address, :phone_number]

  normalizes :email_address, with: ->(e) { e.strip.downcase }
  validates :email_address, :phone_number, :first_name, :last_name, presence: true
  
  # filter_records is now handled by Queryable concern
  # with dynamic ES/DB switching.


  def name
    "#{first_name} #{last_name}"
  end

  def has_permission?(action, subject_class)
    # Role admin has all permissions
    return true if admin?
    
    return false unless user_group
    
    user_group.permissions.exists?(action: [action.to_s, 'manage'], subject_class: [subject_class.to_s, 'all'])
  end

  def search_data
    {
      first_name: first_name,
      last_name: last_name,
      email_address: email_address,
      phone_number: phone_number,
      role: role,
      gender: gender,
      status: status
    }
  end
end
