require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "LabMembership" do
  
  it "should provide the associated lab group" do
    lab_group = mock_model(LabGroup)
    LabGroup.should_receive(:find).
      with(3).
      and_return(lab_group)
    lab_membership = LabMembership.new
    lab_membership.should_receive(:lab_group_id).and_return(3)
    lab_membership.lab_group.should == lab_group
  end

  it "should provide the associated user" do
    user = mock_model(User)
    User.should_receive(:find).
      with(3).
      and_return(user)
    lab_membership = LabMembership.new
    lab_membership.should_receive(:user_id).and_return(3)
    lab_membership.user.should == user
  end

  it "should find memberships by lab group id" do
    lab_membership_1 = mock_model(LabMembership)
    lab_membership_2 = mock_model(LabMembership)
    LabMembership.should_receive(:find).with(
      :all,
      :params => { :lab_group_id => 13 }
    ).and_return([lab_membership_1, lab_membership_2])

    LabMembership.find_by_lab_group_id(13).should == [lab_membership_1, lab_membership_2]
  end

end
