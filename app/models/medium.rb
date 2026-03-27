class Medium < ApplicationRecord
  belongs_to :user, optional: true
  has_one_attached :file

  validates :name, presence: true
  
  def image?
    file_type&.start_with?('image/')
  end

  def icon_class
    case file_type
    when /image/ then 'ki-filled ki-image'
    when /pdf/ then 'ki-filled ki-file-pdf'
    when /video/ then 'ki-filled ki-vimeo'
    else 'ki-filled ki-file'
    end
  end
end
