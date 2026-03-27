class ApplicationController < ActionController::Base
  include Pagy::Backend
  include Authentication
  include Authorization
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Global RBAC Security enforcement for Admin Dashboard
  before_action :enforce_admin_authorization!, if: -> { request.path.start_with?('/admin') }

  private

  def enforce_admin_authorization!
    # Skip auth matching for logins or public stuff mounted in admin
    return if ['sessions', 'passwords', 'registrations'].include?(controller_name)
    authorize_action!
  end
end
