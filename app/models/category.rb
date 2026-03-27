class Category < ApplicationRecord
  has_many :articles, dependent: :nullify
  belongs_to :parent, class_name: 'Category', optional: true
  has_many :children, class_name: 'Category', foreign_key: 'parent_id', dependent: :destroy

  # SEO Data
  has_one :seo_meta, as: :seoable, dependent: :destroy
  accepts_nested_attributes_for :seo_meta

  validates :name, :slug, presence: true
  validates :slug, uniqueness: true

  before_validation :generate_slug, if: -> { name.present? && slug.blank? }

  private

  def generate_slug
    self.slug = name.parameterize
  end
end
