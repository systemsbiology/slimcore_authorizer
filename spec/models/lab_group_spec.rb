require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "LabGroup" do

  it "should provide the associated lab group profile" do
    lab_group = LabGroup.create
    profile = LabGroupProfile.create(:lab_group => lab_group)
    lab_group.lab_group_profile.should == profile
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
    lab_group = LabGroup.create(
      :name => "Fungus Group"
    )
    other_lab_group = LabGroup.new
    user_1 = User.create
    user_2 = User.create
    user_3 = User.create

    lab_membership_1 = LabMembership.create(:lab_group_id => lab_group.id, :user_id => user_1.id)
    lab_membership_2 = LabMembership.create(:lab_group_id => lab_group.id, :user_id => user_2.id)
    lab_membership_3 = LabMembership.create(:lab_group_id => other_lab_group.id, :user_id => user_3.id)

    lab_group.users.should == [user_1, user_2]
  end 
end
