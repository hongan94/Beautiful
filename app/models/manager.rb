class Manager < User
  default_scope { where(role: :admin) }

  before_validation :set_admin_role

  private

  def set_admin_role
    self.role = :admin
  end
end
