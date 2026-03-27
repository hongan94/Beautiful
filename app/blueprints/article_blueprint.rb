class ArticleBlueprint < Blueprinter::Base
  identifier :id
  
  fields :title, :slug, :excerpt, :status, :published_at, :created_at, :updated_at
  
  field :content do |article, options|
    article.content.to_s if article.respond_to?(:content)
  end

  association :category, blueprint: CategoryBlueprint, default: nil
  association :tags, blueprint: TagBlueprint

  view :detail do
    association :seo_meta, blueprint: SeoMetaBlueprint
  end
end
