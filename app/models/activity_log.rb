class ActivityLog < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :trackable, polymorphic: true, optional: true

  validates :action, presence: true

  # Fetch human readable message
  def message
    actor = user ? user.name : "System"
    target = trackable ? trackable.class.name : "Unknown resource"
    "#{actor} #{action} an item on #{target}"
  end
end
