require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "User" do

  it "should provide the associated user profile" do
    profile = mock("User profile")
    UserProfile.should_receive(:find_or_create_by_user_id).
      with(3).
      and_return(profile)
    user = User.new
    user.should_receive(:id).and_return(3)
    user.user_profile.should == profile
  end

  it "should provide the associated lab memberships" do
    lab_memberships = mock("Array of memberships")
    LabMembership.should_receive(:find).
      with(:all, :params => { :user_id => 3 }).
      and_return(lab_memberships)
    user = User.new
    user.should_receive(:id).and_return(3)
    user.lab_memberships.should == lab_memberships
  end

  it "should find a user given their login" do
    user = mock_model(User)
    User.should_receive(:find).with(
      :all,
      :params => { :login => 'jsmith' }
    ).and_return([user])
    
    User.find_by_login("jsmith").should == user
  end

  describe "finding or creating a user by login" do

    it "should find a user if they already exist" do
      user = mock_model(User)
      User.should_receive(:find).with(
        :all,
        :params => { :login => 'jsmith' }
      ).and_return([user])
      
      User.find_or_create_by_login("jsmith").should == user
    end

    it "should create a new user if one doesn't exist" do
      user = mock_model(User)
      User.should_receive(:find).with(
        :all,
        :params => { :login => 'jsmith' }
      ).and_return([])
      User.should_receive(:create).with(:login => "jsmith").
        and_return(user)
      
      User.find_or_create_by_login("jsmith").should == user
    end

  end

  it "should provide the user's lab groups" do
    user = User.new #mock_model(User)
    user.should_receive(:id).and_return(3)

    lab_groups = mock("Array of lab groups")
    LabGroup.should_receive(:find).with(
      :all,
      :params => { :user_id => 3 }
    ).and_return(lab_groups)
    
    user.lab_groups.should == lab_groups
  end

  describe "checking if the user is a staff or admin" do
    
    it "should return false if the user's profile indicates they're not" do
      profile = mock("UserProfile")
      UserProfile.should_receive(:find_or_create_by_user_id).with(3).and_return(profile)
      profile.should_receive(:staff_or_admin?).and_return(true)
      user = mock_model(User)
      user = User.new
      user.should_receive(:id).and_return(3)
      user.staff_or_admin?.should be_true
    end

    it "should return true if the users' profile indicates they are" do
      profile = mock("UserProfile")
      UserProfile.should_receive(:find_or_create_by_user_id).with(3).and_return(profile)
      profile.should_receive(:staff_or_admin?).and_return(false)
      user = mock_model(User)
      user = User.new
      user.should_receive(:id).and_return(3)
      user.staff_or_admin?.should be_false
    end

  end

  describe "checking if the user is an admin" do
    
    it "should return false if the user's profile indicates they're not" do
      profile = mock("UserProfile")
      UserProfile.should_receive(:find_or_create_by_user_id).with(3).and_return(profile)
      profile.should_receive(:admin?).and_return(true)
      user = mock_model(User)
      user = User.new
      user.should_receive(:id).and_return(3)
      user.admin?.should be_true
    end

    it "should return true if the user's profile indicates they are" do
      profile = mock("UserProfile")
      UserProfile.should_receive(:find_or_create_by_user_id).with(3).and_return(profile)
      profile.should_receive(:admin?).and_return(false)
      user = mock_model(User)
      user = User.new
      user.should_receive(:id).and_return(3)
      user.admin?.should be_false
    end

  end

  it "should provide a Hash of users keyed by user id" do
    user_1 = mock_model(User)
    user_2 = mock_model(User)

    User.should_receive(:find).with(:all).and_return( [user_1,user_2] ) 

    User.all_by_id.should == {
      user_1.id => user_1,
      user_2.id => user_2
    }
  end

  it "should provide a hash of summary attributes" do
    user = User.new(
      :login => "jsmith",
      :updated_at => DateTime.now
    )

    user.summary_hash.should == {
      :id => user.id,
      :login => "jsmith",
      :updated_at => user.updated_at,
      :uri => "http://example.com/users/#{user.id}"
    }
  end

  it "should provide a hash of detailed attributes" do
    lab_group_1 = mock_model(LabGroup)
    lab_group_2 = mock_model(LabGroup)

    user = User.new(
      :login => "jsmith",
      :email => "jsmith@example.com",
      :firstname => "Joe",
      :lastname => "Smith",
      :updated_at => DateTime.now
    )
    user.stub!(:lab_groups).and_return([lab_group_1, lab_group_2])

    lab_group_1.stub!(:users).and_return([user])
    lab_group_2.stub!(:users).and_return([user])

    lab_membership_1 = LabMembership.new(:lab_group_id => lab_group_1.id, :user_id => user.id)
    lab_membership_2 = LabMembership.new(:lab_group_id => lab_group_2.id, :user_id => user.id)

    LabMembership.should_receive(:find).
      with(:all, :conditions => {:user_id => user.id}).
      and_return([lab_membership_1, lab_membership_2])

    profile = mock("Profile", :detail_hash => {:a => "b", :c => "d"})
    user.should_receive(:user_profile).and_return(profile)

    user.detail_hash.should == {
      :id => user.id,
      :login => "jsmith",
      :email => "jsmith@example.com",
      :firstname => "Joe",
      :lastname => "Smith",
      :updated_at => user.updated_at,
      :lab_group_uris => ["http://example.com/lab_groups/#{lab_group_1.id}",
                          "http://example.com/lab_groups/#{lab_group_2.id}"],
      :a => "b",
      :c => "d"
    }
  end

end
