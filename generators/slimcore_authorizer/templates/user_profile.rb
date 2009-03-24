class UserProfile < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :user_id
           
  # Manually provide a list of column names that should be shown in the users/index view, since 
  # ActiveResource doesn't seem to provide an easy way to do this.
  #
  # By default this include 'role' to allow role-based access
  class << self; attr_accessor :index_columns end
  @index_columns = ['role']

  ###############################################################################################
  # Authorization:
  #
  # By default a user's role is determined by looking at the column 'role' in the UserProfile 
  # model
  ###############################################################################################
  
  def staff_or_admin?
    role == "staff" || role == "admin"
  end
 
  def admin?
    role == "admin"
  end
end
