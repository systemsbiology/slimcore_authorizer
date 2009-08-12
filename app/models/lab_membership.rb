class LabMembership < ActiveResource::Base
  self.site = APP_CONFIG['slimcore_site'] 
  self.user = APP_CONFIG['slimcore_user']
  self.password = APP_CONFIG['slimcore_password'] 

  def lab_group
    LabGroup.find(lab_group_id)
  end

  def user
    User.find(user_id)
  end

  def self.find_by_lab_group_id(lab_group_id)
    self.find(:all, :params => {:lab_group_id => lab_group_id})
  end
end
