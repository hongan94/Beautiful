class ManagerBlueprint < Blueprinter::Base
  identifier :id

  fields :name, :email_address, :phone_number, :gender, :address, :status

  field :created_at do |manager, _options|
    manager.created_at.strftime("%Y-%m-%d %H:%M:%S")
  end

  field :avatar_url do |manager, _options|
    if manager.respond_to?(:avatar_url) && manager.avatar_url.attached?
      Rails.application.routes.url_helpers.rails_blob_url(manager.avatar_url, only_path: true)
    else
      ActionController::Base.helpers.asset_path('avatars/300-3.png')
    end
  end
end
