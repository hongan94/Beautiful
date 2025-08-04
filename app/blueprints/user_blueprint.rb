class UserBlueprint < Blueprinter::Base
    identifier :id
  
    fields :name, :email_address, :phone_number, :gender, :address, :status

    field :created_at do |manager, _options|
        manager.created_at.strftime("%Y-%m-%d %H:%M:%S")
      end
    
    field :avatar_url do |user, _options|
      if user.respond_to?(:avatar_url) && user.avatar_url.attached?
        Rails.application.routes.url_helpers.rails_blob_url(user.avatar_url, only_path: true)
      else
        ActionController::Base.helpers.asset_path('avatars/300-3.png')
      end
    end
  end
  