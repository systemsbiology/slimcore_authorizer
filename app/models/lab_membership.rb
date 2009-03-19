class LabMembership < ActiveResource::Base
  self.site = APP_CONFIG['slimcore_site'] 
  self.user = APP_CONFIG['slimcore_user']
  self.password = APP_CONFIG['slimcore_password'] 

  #belongs_to :lab_group
  #belongs_to :user
end
