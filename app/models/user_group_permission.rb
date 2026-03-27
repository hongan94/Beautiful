class UserGroupPermission < ApplicationRecord
  belongs_to :user_group
  belongs_to :permission
end
