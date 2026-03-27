class UserGroup < ApplicationRecord
  has_many :user_group_permissions, dependent: :destroy
  has_many :permissions, through: :user_group_permissions
  has_many :users

  validates :name, presence: true, uniqueness: true
end
