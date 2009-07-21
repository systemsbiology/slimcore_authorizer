require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "LabGroup" do

  it "should provide the associated lab group profile" do
    profile = mock("Lab group profile")
    LabGroupProfile = mock("LabGroupProfile")
    LabGroupProfile.should_receive(:find_or_create_by_lab_group_id).
      with(3).
      and_return(profile)
    lab_group = LabGroup.new
    lab_group.should_receive(:id).and_return(3)
    lab_group.lab_group_profile.should == profile
  end

#  it "should destroy the associated lab group profile when it's destroyed" do
#    profile = mock("Lab group profile")
#    lab_group = LabGroup.new
#    lab_group.should_receive(:lab_group_profile).and_return(profile)
#    profile.should_receive(:destroy)
#    lab_group.destroy
#  end
  #
  it "should find a lab group given its name" do
    lab_group = mock_model(LabGroup)
    LabGroup.should_receive(:find).with(
      :all,
      :params => { :name => 'Yeast Group' }
    ).and_return([lab_group])
    
    LabGroup.find_by_name("Yeast Group").should == lab_group
  end

  it "should return nil if finding by name with a nil name parameter" do
    LabGroup.should_receive(:find).with(
      :all,
      :params => { :name => nil }
    ).and_return([])
    
    LabGroup.find_by_name(nil).should == nil
  end

  it "should provide a hash of summary attributes" do
    lab_group = LabGroup.new(
      :name => "Fungus Group",
      :updated_at => DateTime.now
    )

    lab_group.summary_hash.should == {
      :id => lab_group.id,
      :name => "Fungus Group",
      :updated_at => lab_group.updated_at,
      :uri => "http://example.com/lab_groups/#{lab_group.id}"
    }
  end

  it "should provide a hash of detailed attributes" do
    lab_group = LabGroup.new(
      :name => "Fungus Group",
      :updated_at => DateTime.now
    )
    user_1 = mock_model(User, :lab_groups => [lab_group])
    user_2 = mock_model(User, :lab_groups => [lab_group])

    lab_membership_1 = LabMembership.new(:lab_group_id => lab_group.id, :user_id => user_1.id)
    lab_membership_2 = LabMembership.new(:lab_group_id => lab_group.id, :user_id => user_2.id)

    LabMembership.should_receive(:find).
      with(:all, :conditions => {:lab_group_id => lab_group.id}).
      and_return([lab_membership_1, lab_membership_2])

    profile = mock("Profile", :detail_hash => {:a => "b", :c => "d"})
    lab_group.should_receive(:lab_group_profile).and_return(profile)

    lab_group.detail_hash.should == {
      :id => lab_group.id,
      :name => "Fungus Group",
      :updated_at => lab_group.updated_at,
      :user_uris => ["http://example.com/users/#{user_1.id}",
                     "http://example.com/users/#{user_2.id}"],
      :a => "b",
      :c => "d"
    }
  end

  it "should provide a Hash of lab groups keyed by lab group id" do
    lab_group_1 = mock_model(LabGroup)
    lab_group_2 = mock_model(LabGroup)

    LabGroup.should_receive(:find).with(:all).and_return( [lab_group_1,lab_group_2] ) 

    LabGroup.all_by_id.should == {
      lab_group_1.id => lab_group_1,
      lab_group_2.id => lab_group_2
    }
  end

  it 'should provide the users who belong to a lab group' do
    lab_group = LabGroup.new(
      :name => "Fungus Group",
      :updated_at => DateTime.now
    )
    user_1 = mock_model(User, :lab_groups => [lab_group])
    user_2 = mock_model(User, :lab_groups => [lab_group])

    lab_membership_1 = LabMembership.new(:lab_group_id => lab_group.id, :user_id => user_1.id)
    lab_membership_2 = LabMembership.new(:lab_group_id => lab_group.id, :user_id => user_2.id)

    LabMembership.should_receive(:find).
      with(:all, :conditions => {:lab_group_id => lab_group.id}).
      and_return([lab_membership_1, lab_membership_2])
    User.should_receive(:find).with(user_1.id).and_return(user_1)
    User.should_receive(:find).with(user_2.id).and_return(user_2)

    lab_group.users.should == [user_1, user_2]
  end 
end
