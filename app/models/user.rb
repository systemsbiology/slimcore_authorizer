class User < ActiveResource::Base
  self.site = APP_CONFIG['slimcore_site'] 
  self.user = APP_CONFIG['slimcore_user']
  self.password = APP_CONFIG['slimcore_password'] 
  
  #has_many :lab_memberships, :dependent => :destroy
  #has_many :lab_groups, :through => :lab_memberships
  #has_many :samples, :foreign_key => "submitted_by_id"
  #belongs_to :naming_scheme, :foreign_key => "current_naming_scheme_id"

  def user_profile
    UserProfile.find_or_create_by_user_id(self.id)
  end

  def lab_memberships
    LabMembership.find(:all, :params => { :user_id => self.id })
  end

  def self.find_by_login(login)
    self.find(:all, :params => {:login => login}).first
  end

  def staff_or_admin?
    UserProfile.find_by_user_id(id).staff_or_admin?
  end

  def admin?
    UserProfile.find_by_user_id(id).admin?
  end

  # Returns the full name of this user.
  def fullname
    full_name
  end
  
  def full_name
    "#{firstname} #{lastname}"
  end

  # Returns an Array of the ids of quality traces the user has access to
  def get_lab_group_ids
    @lab_groups = accessible_lab_groups
    
    # gather ids of user's lab groups
    lab_group_ids = Array.new
    for lab_group in @lab_groups
      lab_group_ids << lab_group.id
    end
    lab_group_ids.flatten
    
    return lab_group_ids
  end
  
  def accessible_lab_groups
    # Administrators and staff can see all projects, otherwise users
    # are restricted to seeing only projects for lab groups they belong to
    if(self.staff_or_admin?)
      return LabGroup.find(:all, :order => "name ASC")
    else
      return self.lab_groups
    end
  end  
 
  def lab_groups
    LabGroup.find(:all, :params => { :user_id => id })
  end

  def accessible_users
    lab_group_ids = get_lab_group_ids
    return User.find(:all, :include => :lab_memberships,
      :conditions => ["lab_memberships.lab_group_id IN (?)", lab_group_ids],
      :order => "lastname ASC"
    )    
  end
  
  def accessible_projects
    lab_group_ids = get_lab_group_ids
    return Project.find(:all,
      :conditions => ["lab_group_id IN (?)", lab_group_ids],
      :order => "name ASC"
    )
  end

  def self.all_by_id
    user_array = User.find(:all)

    user_hash = Hash.new
    user_array.each do |user|
      user_hash[user.id] = user
    end

    return user_hash
  end

  ####################################################
  # API
  ####################################################
  
  def summary_hash
    return {
      :id => id,
      :login => login,
      :updated_at => updated_at,
      :uri => "#{SiteConfig.site_url}/users/#{id}"
    }
  end

  def detail_hash
    return {
      :id => id,
      :login => login,
      :email => email,
      :firstname => firstname,
      :lastname => lastname,
      :updated_at => updated_at,
      :lab_group_uris => lab_group_ids.sort.
        collect {|x| "#{SiteConfig.site_url}/lab_groups/#{x}" }
    }.merge(user_profile.detail_hash)
  end

private

  def lab_group_ids
    LabMembership.find(:all, :conditions => {:user_id => self.id}).
      collect {|x| x.lab_group_id}
  end
end
