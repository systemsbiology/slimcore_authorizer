class LabGroup < ActiveResource::Base
  self.site = APP_CONFIG['slimcore_site'] 
  self.user = APP_CONFIG['slimcore_user']
  self.password = APP_CONFIG['slimcore_password'] 

#  has_many :projects, :dependent => :destroy
#  has_many :charge_sets, :dependent => :destroy

  def destroy_warning
    charge_sets = ChargeSet.find(:all, :conditions => ["lab_group_id = ?", id])
    
    return "Destroying this lab group will also destroy:\n" + 
           charge_sets.size.to_s + " charge set(s)\n" +
           projects.size.to_s + " project(s)\n" +
           "Are you sure you want to destroy it?"
  end

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
      :file_folder => file_folder,
      :updated_at => updated_at,
      :user_uris => user_ids.sort.
        collect {|x| "#{SiteConfig.site_url}/users/#{x}" },
      :project_uris => project_ids.sort.
        collect {|x| "#{SiteConfig.site_url}/projects/#{x}" }
    }
  end
end
