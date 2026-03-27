class SeoMeta < ApplicationRecord
  belongs_to :seoable, polymorphic: true
  has_one_attached :og_image

  validates :meta_title, presence: true
end
