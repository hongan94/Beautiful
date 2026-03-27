class Article < ApplicationRecord
  # Search & Pagination
  searchkick word_start: [:title]
  extend Pagy::Searchkick
  include Queryable

  self.searchable_columns = [:title, :slug]

  # Associations
  belongs_to :user
  belongs_to :category, optional: true
  has_many :article_tags, dependent: :destroy
  has_many :tags, through: :article_tags

  # SEO Data (Polymorphic)
  has_one :seo_meta, as: :seoable, dependent: :destroy
  accepts_nested_attributes_for :seo_meta

  # Media
  has_rich_text :content if defined?(ActionText)
  has_one_attached :cover_image

  # Status Enum
  enum :status, { draft: 0, published: 1, archived: 2 }, default: :draft

  # Validations
  validates :title, :slug, presence: true
  validates :slug, uniqueness: true

  # Slugs
  before_validation :generate_slug, if: -> { title.present? && slug.blank? }

  # Callbacks for Activity Log
  after_commit :log_activity, on: [:create, :update]

  def search_data
    {
      title: title,
      slug: slug,
      status: status,
      category_id: category_id,
      published_at: published_at
    }
  end

  private

  def generate_slug
    self.slug = title.parameterize
  end

  def log_activity
    return unless Current.user
    
    action = previously_new_record? ? 'created' : 'updated'
    changes_data = saved_changes.except(:updated_at, :created_at)

    ActivityLog.create(
      user: Current.user,
      action: "article_#{action}",
      trackable: self,
      changes_data: changes_data.to_json
    )
  end
end
