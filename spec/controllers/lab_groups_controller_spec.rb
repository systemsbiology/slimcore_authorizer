require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe LabGroupsController do
  include AuthenticatedSpecHelper

  before(:each) do
    login_as_staff
  end

  def mock_lab_group(stubs={})
    @mock_lab_group ||= mock_model(LabGroup, stubs)
  end

  def mock_lab_group_profile
    @mock_lab_group_profile ||= mock("LabGroupProfile")
  end

  describe "responding to GET index" do

    before(:each) do
      @lab_group_1 = mock_model(LabGroup)
      @lab_group_2 = mock_model(LabGroup)
      @lab_groups = [@lab_group_1, @lab_group_2]

      LabGroup.should_receive(:find).with(:all, :order=>"name ASC").and_return(@lab_groups)
    end

    it "should expose all lab_groups as @lab_groups" do
      get :index
      assigns[:lab_groups].should == @lab_groups
    end

    describe "with mime type of xml" do

      it "should render all lab_groups as xml" do
        @lab_group_1.should_receive(:summary_hash).and_return( {:n => 1} )
        @lab_group_2.should_receive(:summary_hash).and_return( {:n => 2} )
        request.env["HTTP_ACCEPT"] = "application/xml"
        get :index
        response.body.should == "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<records type=\"array\">\n  " +
          "<record>\n    <n type=\"integer\">1</n>\n  </record>\n  <record>\n    " +
          "<n type=\"integer\">2</n>\n  </record>\n</records>\n"
      end

    end

    describe "with mime type of json" do

      it "should render flow cell summaries as json" do
        @lab_group_1.should_receive(:summary_hash).and_return( {:n => 1} )
        @lab_group_2.should_receive(:summary_hash).and_return( {:n => 2} )
        request.env["HTTP_ACCEPT"] = "application/json"
        get :index
        response.body.should == "[{\"n\": 1}, {\"n\": 2}]"
      end

    end

  end

  describe "responding to GET show" do

    describe "with mime type of xml" do

      it "should render the requested lab_group as xml" do
        lab_group = mock_model(LabGroup)
        lab_group.should_receive(:detail_hash).and_return( {:n => 1} )

        request.env["HTTP_ACCEPT"] = "application/xml"
        LabGroup.should_receive(:find).with("37").and_return(lab_group)
        get :show, :id => "37"
        response.body.should == "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<hash>\n  "+
          "<n type=\"integer\">1</n>\n</hash>\n"
      end

    end

    describe "with mime type of json" do

      it "should render the flow cell detail as json" do
        lab_group = mock_model(LabGroup)
        lab_group.should_receive(:detail_hash).and_return( {:n => 1} )

        request.env["HTTP_ACCEPT"] = "application/json"
        LabGroup.should_receive(:find).with("37").and_return(lab_group)
        get :show, :id => 37
        response.body.should == "{\"n\": 1}"
      end

    end

  end

  describe "responding to GET new" do
    before(:each) do
      @lab_group = mock_lab_group
      LabGroup.should_receive(:new).and_return(@lab_group)
      @lab_group_lanes = [mock_model(LabGroup),mock_model(LabGroup)]
      @lab_group.stub!(:lab_group_lanes).and_return(@lab_group_lanes)
      @lab_group_lanes.stub!(:build)
    end

    it "should expose a new lab_group as @lab_group" do
      get :new
      assigns[:lab_group].should equal(@lab_group)
    end

  end

  describe "responding to GET edit" do

    it "should expose the requested lab_group as @lab_group" do
      LabGroup.should_receive(:find).with("37").and_return(mock_lab_group)
      mock_lab_group.should_receive(:lab_group_profile).and_return(mock_lab_group_profile)
      get :edit, :id => "37"
      assigns[:lab_group].should equal(mock_lab_group)
    end

  end

  describe "responding to POST create" do

    describe "with valid params" do

      it "should expose a newly created lab_group as @lab_group" do
        LabGroup.should_receive(:new).with({'these' => 'params'}).and_return(mock_lab_group(:save => true))
        post :create, :lab_group => {:these => 'params'}
        assigns(:lab_group).should equal(mock_lab_group)
      end

      it "should redirect to the created lab_group" do
        LabGroup.stub!(:new).and_return(mock_lab_group(:save => true))
        post :create, :lab_group => {}
        response.should redirect_to(lab_groups_url)
      end

    end

    describe "with invalid params" do

      it "should expose a newly created but unsaved lab_group as @lab_group" do
        LabGroup.stub!(:new).with({'these' => 'params'}).and_return(mock_lab_group(:save => false))
        post :create, :lab_group => {:these => 'params'}
        assigns(:lab_group).should equal(mock_lab_group)
      end

      it "should re-render the 'new' template" do
        LabGroup.stub!(:new).and_return(mock_lab_group(:save => false))
        post :create, :lab_group => {}
        response.should render_template('new')
      end

    end

  end

  describe "responding to PUT udpate" do

    def do_update
      put :update, :id => "37", :lab_group => {:these => 'params'}, :lab_group_profile => {:those => 'params'}
    end

    describe "with valid params" do

      before(:each) do
        LabGroup.stub!(:find).and_return(mock_lab_group)
        mock_lab_group.stub!(:load).and_return(true)
        mock_lab_group.stub!(:save).and_return(true)
        mock_lab_group.stub!(:lab_group_profile).and_return(mock_lab_group_profile)
        mock_lab_group_profile.stub!(:update_attributes).and_return(true)
      end

      it "should find the lab_group" do
        LabGroup.should_receive(:find).with("37").and_return(mock_lab_group)
        do_update
      end

      it "should find the lab_group profile" do
        mock_lab_group.should_receive(:lab_group_profile).and_return(mock_lab_group_profile)
        do_update
      end

      it "should load the updates into the lab_group" do
        mock_lab_group.should_receive(:load).with({'these' => 'params'}).and_return(true)
        do_update
      end

      it "should save the lab_group" do
        mock_lab_group.should_receive(:save).and_return(true)
        do_update
      end

      it "should update the lab_group profile" do
        mock_lab_group_profile.should_receive(:update_attributes).
          with({'those' => 'params'}).and_return(true)
        do_update
      end

      it "should expose the requested lab_group as @lab_group" do
        do_update
        assigns(:lab_group).should equal(mock_lab_group)
      end

      it "should expose the lab_group_profile as @lab_group_profile" do
        do_update
        assigns(:lab_group_profile).should equal(mock_lab_group_profile) 
      end

      it "should redirect to the lab_group" do
        do_update
        response.should redirect_to(lab_groups_url)
      end

    end

    describe "with invalid lab_group params" do

      before(:each) do
        LabGroup.stub!(:find).and_return(mock_lab_group)
        mock_lab_group.stub!(:load).and_return(false)
        mock_lab_group.stub!(:lab_group_profile).and_return(mock_lab_group_profile)
      end

      it "should update the requested lab_group" do
        mock_lab_group.should_receive(:load).with({'these' => 'params'})
        do_update
      end

      it "should expose the lab_group as @lab_group" do
        do_update
        assigns(:lab_group).should equal(mock_lab_group)
      end

      it "should expose the lab_group_profile as @lab_group_profile" do
        do_update
        assigns(:lab_group_profile).should equal(mock_lab_group_profile) 
      end

      it "should re-render the 'edit' template" do
        do_update
        response.should render_template('edit')
      end

    end

  end

  describe "responding to DELETE destroy" do

    before(:each) do
      mock_lab_group.stub!(:destroy)
      LabGroup.should_receive(:find).with("37").and_return(mock_lab_group)
    end

    it "should destroy the requested lab_group" do
      mock_lab_group.should_receive(:destroy)
      delete :destroy, :id => "37"
    end

    it "should redirect to the lab_groups list" do
      delete :destroy, :id => "37"
      response.should redirect_to(lab_groups_url)
    end

  end

end
