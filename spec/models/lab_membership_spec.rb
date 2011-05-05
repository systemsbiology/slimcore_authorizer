require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "LabMembership" do
  
  it "should provide the associated lab group" do
    lab_group = LabGroup.create
    lab_membership = LabMembership.create(:lab_group => lab_group)
    lab_membership.lab_group.should == lab_group
  end

  it "should provide the associated user" do
    user = User.create
    lab_membership = LabMembership.create(:user => user)
    lab_membership.user.should == user
  end

  it "should find memberships by lab group id" do
    lab_group = LabGroup.create
    lab_membership_1 = LabMembership.create(:lab_group => lab_group, :user => User.create)
    lab_membership_2 = LabMembership.create(:lab_group => lab_group, :user => User.create)
    LabMembership.find_all_by_lab_group_id(lab_group.id).should == [lab_membership_1, lab_membership_2]
  end

end
