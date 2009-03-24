class LabGroup < ActiveResource::Base
  self.site = APP_CONFIG['slimcore_site'] 
  self.user = APP_CONFIG['slimcore_user']
  self.password = APP_CONFIG['slimcore_password'] 

  def lab_group_profile
    LabGroupProfile.find_or_create_by_lab_group_id(self.id)
  end

  # destroy the associated lab group profile, which is responsible
  # for destroying any application-specific associated records
#  def destroy
#    self.lab_group_profile.destroy
#    super(destroy)
#  end

  ####################################################
  # API
  ####################################################

  def summary_hash
    return {
      :id => id,
      :name => name,
      :updated_at => updated_at,
      :uri => "#{SiteConfig.site_url}/lab_groups/#{id}"
    }
  end

  def detail_hash
    return {
      :id => id,
      :name => name,
      :updated_at => updated_at,
      :user_uris => user_ids.sort.
        collect {|x| "#{SiteConfig.site_url}/users/#{x}" },
    }.merge(lab_group_profile.detail_hash)
  end

private

  def user_ids
    LabMembership.find(:all, :conditions => {:lab_group_id => self.id}).
      collect {|x| x.user_id}
  end
end
