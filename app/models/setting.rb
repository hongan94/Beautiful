class Setting < ApplicationRecord
  validates :key, presence: true, uniqueness: true

  # Usage: Setting.get('site_name') or Setting.fetch('site_name', 'Mặc định')
  def self.get(key)
    find_by(key: key)&.value
  end

  def self.set(key, val, desc = nil)
    setting = find_or_initialize_by(key: key)
    setting.value = val
    setting.description = desc if desc.present?
    setting.save
  end
end
