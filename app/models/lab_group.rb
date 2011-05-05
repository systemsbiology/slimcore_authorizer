class LabGroup < ActiveRecord::Base
  extend ApiAccessible

  establish_connection "slimcore_#{Rails.env}"

  has_many :lab_memberships
  has_many :users, :through => :lab_memberships

  def lab_group_profile
    LabGroupProfile.find_or_create_by_lab_group_id(self.id)
  end

  def self.all_by_id
    lab_group_array = LabGroup.find(:all)

    lab_group_hash = Hash.new
    lab_group_array.each do |lab_group|
      lab_group_hash[lab_group.id] = lab_group
    end

    return lab_group_hash
  end

  ####################################################
  # API
  ####################################################

  def summary_hash(with = nil)
    hash = {
      :id => id,
      :name => name,
      :updated_at => updated_at,
      :uri => "#{APP_CONFIG['site_url']}/lab_groups/#{id}"
    }

    if(with)
      with.split(",").each do |key|
        key = key.to_sym

        if LabGroup.api_methods.include? key
          hash[key] = self.send(key)
        end
      end
    end

    return hash
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

  api_reader :project_ids
  def project_ids
    projects = Project.find(:all, :conditions => {:lab_group_id => id})

    return projects.collect {|p| p.id}
  end

  def self.populated_for_user(user)
    all_lab_groups = LabGroup.find(:all, :order => "name ASC")

    lab_group_ids = user.get_lab_group_ids

    populated_lab_groups = all_lab_groups.select do |lab_group|
      Sample.find(:all, :include => {:microarray => {:chip => {:sample_set => :project}}},
        :conditions => ["projects.lab_group_id = ?", lab_group.id]).size > 0
    end

    return populated_lab_groups
  end

private

  def user_ids
    LabMembership.find(:all, :conditions => {:lab_group_id => self.id}).
      collect {|x| x.user_id}
  end
end
