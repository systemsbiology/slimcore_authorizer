module Authorization
  def staff_or_admin_required
    UserProfile.find_by_user_id(current_user.id).staff_or_admin? || insufficient_privileges
  end
  
  def admin_required
    UserProfile.find_by_user_id(current_user.id).admin? || insufficient_privileges
  end
  
  def insufficient_privileges
    redirect_to :controller => "welcome"
  end
end
