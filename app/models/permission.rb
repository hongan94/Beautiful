class Permission < ApplicationRecord
  has_many :user_group_permissions, dependent: :destroy
  has_many :user_groups, through: :user_group_permissions

  validates :action, presence: true
  validates :subject_class, presence: true
end
