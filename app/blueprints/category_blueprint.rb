class CategoryBlueprint < Blueprinter::Base
  identifier :id
  fields :name, :slug, :description, :parent_id
  
  view :detail do
    association :seo_meta, blueprint: SeoMetaBlueprint
  end
end
