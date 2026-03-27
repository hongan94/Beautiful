class SeoMetaBlueprint < Blueprinter::Base
  identifier :id
  fields :meta_title, :meta_description, :meta_keywords, :og_image_url
  
  field :og_image do |seo_meta, options|
    seo_meta.og_image.attached? ? Rails.application.routes.url_helpers.rails_blob_url(seo_meta.og_image, only_path: true) : nil
  end
end
