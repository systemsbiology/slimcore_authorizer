class LabGroup < ActiveResource::Base
  self.site = APP_CONFIG['slimcore_site'] 
  self.user = APP_CONFIG['slimcore_user']
  self.password = APP_CONFIG['slimcore_password'] 

  def lab_group_profile
    LabGroupProfile.find_or_create_by_lab_group_id(self.id)
  end

  def self.find_by_name(name)
    self.find(:all, :params => {:name => name}).first
  end

  # destroy the associated lab group profile, which is responsible
  # for destroying any application-specific associated records
#  def destroy
#    self.lab_group_profile.destroy
#    super(destroy)
#  end

  def self.all_by_id
    lab_group_array = LabGroup.find(:all)

    lab_group_hash = Hash.new
    lab_group_array.each do |lab_group|
      lab_group_hash[lab_group.id] = lab_group
    end

    return lab_group_hash
  end

  def users
    LabMembership.find_by_lab_group_id(self.id).
      collect {|x| x.user}
  end

  ####################################################
  # API
  ####################################################

  def summary_hash
    return {
      :id => id,
      :name => name,
      :updated_at => updated_at,
      :uri => "#{APP_CONFIG['site_url']}/lab_groups/#{id}"
    }
  end

  def detail_hash
    return {
      :id => id,
      :name => name,
      :updated_at => updated_at,
      :user_uris => user_ids.sort.
        collect {|x| "#{APP_CONFIG['site_url']}/users/#{x}" },
    }.merge(lab_group_profile.detail_hash)
  end

private

  def user_ids
    LabMembership.find(:all, :conditions => {:lab_group_id => self.id}).
      collect {|x| x.user_id}
  end
end
