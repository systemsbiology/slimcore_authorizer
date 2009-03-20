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
end
