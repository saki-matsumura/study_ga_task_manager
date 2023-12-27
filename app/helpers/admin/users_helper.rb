module Admin::UsersHelper
  def admin?
    return false unless current_user.roll == 'admin'
    true
  end
end