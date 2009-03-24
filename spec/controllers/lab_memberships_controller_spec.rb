require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe LabMembershipsController do
  include AuthenticatedSpecHelper

  before(:each) do
    login_as_staff
  end

  def mock_lab_membership(stubs={})
    @mock_lab_membership ||= mock_model(LabMembership, stubs)
  end

  def mock_user(stubs={})
    @mock_user ||= mock_model(User, stubs)
  end

  describe "responding to GET index" do

    before(:each) do
      @lab_membership_1 = mock_model(LabMembership)
      @lab_membership_2 = mock_model(LabMembership)
      @lab_memberships = [@lab_membership_1, @lab_membership_2]

      User.should_receive(:find).with("3").and_return(mock_user)
      mock_user.should_receive(:lab_memberships).and_return(@lab_memberships)
    end

    def do_get
      get :index, :user_id => 3
    end
    
    it "should expose all lab_memberships as @lab_memberships" do
      do_get
      assigns[:lab_memberships].should == @lab_memberships
    end

    describe "with default mime type" do
      
      it "should render the index template" do
        do_get
        response.should render_template('index')
      end

    end

    describe "with mime type of xml" do

      it "should render all lab_memberships as xml" do
        @lab_memberships.should_receive(:to_xml).and_return( "lab_memberships XML" )
        request.env["HTTP_ACCEPT"] = "application/xml"
        do_get
        response.body.should == "lab_memberships XML"
      end

    end

  end

  describe "responding to GET new" do
    before(:each) do
      User.should_receive(:find).with("3").and_return(mock_user)
      LabMembership.should_receive(:new).
        with(:user_id => mock_user.id, :lab_group_id => nil).
        and_return(mock_lab_membership)
    end

    it "should expose a new lab_membership as @lab_membership" do
      get :new, :user_id => 3
      assigns[:lab_membership].should equal(mock_lab_membership)
    end

  end

  describe "responding to GET edit" do

    it "should expose the requested lab_membership as @lab_membership" do
      LabMembership.should_receive(:find).with("37").and_return(mock_lab_membership)
      mock_lab_membership.should_receive(:user).and_return(mock_user)
      get :edit, :id => "37"
      assigns[:lab_membership].should equal(mock_lab_membership)
      assigns[:user].should equal(mock_user)
    end

  end

  describe "responding to POST create" do

    before(:each) do
      LabMembership.should_receive(:new).
        with({'these' => 'params'}).
        and_return(mock_lab_membership)
      mock_lab_membership.should_receive(:user).and_return(mock_user)
    end

    def do_post
      post :create, :lab_membership => {:these => 'params'}
    end

    describe "with valid params" do

      it "should expose a newly created lab_membership as @lab_membership" do
        mock_lab_membership.should_receive(:save).and_return(true)
        do_post
        assigns(:lab_membership).should equal(mock_lab_membership)
      end

      it "should redirect to the listing of lab memberships for this user" do
        mock_lab_membership.should_receive(:save).and_return(true)
        do_post
        response.should redirect_to( user_lab_memberships_url(mock_user) )
      end

    end

    describe "with invalid params" do

      it "should expose a newly created but unsaved lab_membership as @lab_membership" do
        mock_lab_membership.should_receive(:save).and_return(false)
        do_post
        assigns(:lab_membership).should equal(mock_lab_membership)
      end

      it "should re-render the 'new' template" do
        mock_lab_membership.should_receive(:save).and_return(false)
        do_post
        response.should render_template('new')
      end

    end

  end

  describe "responding to PUT udpate" do

    before(:each) do
      LabMembership.should_receive(:find).with("37").and_return(mock_lab_membership)
      mock_lab_membership.should_receive(:user).and_return(mock_user)
      mock_lab_membership.should_receive(:load).with({'these' => 'params'}).and_return(true)
    end

    def do_put
      put :update, :id => "37", :lab_membership => {:these => 'params'}
    end

    describe "with valid params" do

      before(:each) do
        mock_lab_membership.stub!(:save).and_return(true)
      end

      it "should update the requested lab_membership" do
        mock_lab_membership.should_receive(:save).and_return(true)
        do_put
      end

      it "should expose the requested lab_membership as @lab_membership" do
        do_put
        assigns(:lab_membership).should equal(mock_lab_membership)
      end

      it "should redirect to the lab_membership" do
        do_put
        response.should redirect_to( user_lab_memberships_url(mock_user) )
      end

    end

    describe "with invalid params" do

      before(:each) do
       mock_lab_membership.stub!(:save).and_return(false)
      end

      it "should update the requested lab_membership" do
        mock_lab_membership.should_receive(:save).and_return(false)
        do_put
      end

      it "should expose the lab_membership as @lab_membership" do
        do_put
        assigns(:lab_membership).should equal(mock_lab_membership)
      end

      it "should re-render the 'edit' template" do
        do_put
        response.should render_template('edit')
      end

    end

  end

  describe "responding to DELETE destroy" do

    before(:each) do
      LabMembership.should_receive(:find).with("37").and_return(mock_lab_membership)
      mock_lab_membership.should_receive(:user).and_return(mock_user)
      mock_lab_membership.stub!(:destroy)
    end

    it "should destroy the requested lab_membership" do
      mock_lab_membership.should_receive(:destroy)
      delete :destroy, :id => "37"
    end

    it "should redirect to the lab_memberships list" do
      delete :destroy, :id => "37"
      response.should redirect_to( user_lab_memberships_url(mock_user) )
    end

  end

end
