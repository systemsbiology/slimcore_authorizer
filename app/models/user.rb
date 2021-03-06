class User < ActiveRecord::Base
  establish_connection "slimcore_#{Rails.env}"

  has_many :lab_memberships
  has_many :lab_groups, :through => :lab_memberships

  def user_profile
    UserProfile.find_or_create_by_user_id(self.id)
  end

  def staff_or_admin?
    UserProfile.find_or_create_by_user_id(id).staff_or_admin?
  end

  def admin?
    UserProfile.find_or_create_by_user_id(id).admin?
  end

  def manager?
    UserProfile.find_or_create_by_user_id(id).manager?
  end

  def investigator?
    UserProfile.find_or_create_by_user_id(id).investigator?
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
    # Administrators and staff can see all lab groups, otherwise users
    # are restricted to seeing only lab groups they belong to
    if(self.staff_or_admin?)
      return LabGroup.find(:all, :order => "name ASC")
    else
      return self.lab_groups
    end
  end  
 
  def accessible_users
    lab_group_ids = get_lab_group_ids
    return User.find(:all, :include => :lab_memberships,
      :conditions => ["lab_memberships.lab_group_id IN (?)", lab_group_ids],
      :order => "lastname ASC"
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

  def self.all_by_login
    user_array = User.find(:all)

    user_hash = Hash.new
    user_array.each do |user|
      user_hash[user.login] = user
    end

    return user_hash
  end

  # need this to prevent this error for some associated models:
  # NoMethodError: undefined method `destroyed?' for #<ActiveRecord::Associations::BelongsToAssociation:0x????????>
  def destroyed?
    false
  end

  ####################################################
  # Passwords
  ####################################################
  
  validates_confirmation_of :password
  
  before_save :encrypt_password

  attr_accessor :password, :password_confirmation

  attr_accessible :login, :email, :firstname, :lastname,
    :password, :password_confirmation

  def encrypt(str)
    generate_encryption_salt unless encryption_salt
    Digest::SHA256.hexdigest("#{encryption_salt}::#{str}")
  end

  def encrypt_password
    self[:encrypted_password] = encrypt(password)
  end

  def generate_encryption_salt
    self.encryption_salt = Digest::SHA1.hexdigest(Crypt::ISAAC.new.rand(2**31).to_s) unless
      encryption_salt
  end


  ####################################################
  # API
  ####################################################
  
  def summary_hash
    return {
      :id => id,
      :login => login,
      :updated_at => updated_at,
      :uri => "#{APP_CONFIG['site_url']}/users/#{id}"
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
        collect {|x| "#{APP_CONFIG['site_url']}/lab_groups/#{x}" }
    }.merge(user_profile.detail_hash)
  end

private

  def lab_group_ids
    LabMembership.find(:all, :conditions => {:user_id => self.id}).
      collect {|x| x.lab_group_id}
  end
end
