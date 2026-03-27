module Authorization
  extend ActiveSupport::Concern

  included do
    helper_method :authorized?

    # You can comment out the next line if you don't want strict ALL endpoints protected by default
    # But usually for a strict CMS, you want:
    # before_action :authorize_admin_request!, if: :is_admin_namespace?
  end

  def authorize_action!(action = action_name, subject = controller_name)
    unless authorized?(action, subject)
      respond_to do |format|
        format.html { redirect_to root_path, alert: "🔐 You are not authorized to perform this action." }
        format.json { render json: { error: "Forbidden: insufficient permissions" }, status: :forbidden }
      end
    end
  end

  def authorized?(action = action_name, subject = controller_name)
    return true unless Current.user # Depending on architecture, rely on Authentication to bounce anonymous users
    
    # Map common rails restful actions to generic permissions
    action_map = {
      'index' => 'read',
      'show' => 'read',
      'new' => 'create',
      'create' => 'create',
      'edit' => 'update',
      'update' => 'update',
      'destroy' => 'delete'
    }

    mapped_action = action_map[action.to_s] || action.to_s
    subject_class = subject.to_s.singularize.camelize

    Current.user.has_permission?(mapped_action, subject_class)
  end

  private

  def is_admin_namespace?
    request.path.start_with?('/admin')
  end
end
