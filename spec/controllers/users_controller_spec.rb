require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe UsersController do
  include AuthenticatedSpecHelper

  before(:each) do
    login_as_staff
  end

  def mock_user(stubs={})
    @mock_user ||= mock_model(User, stubs)
  end

  def mock_user_profile(stubs={})
    @mock_user_profile ||= mock_model(UserProfile, stubs)
  end

  describe "responding to GET index" do

    before(:each) do
      @user_1 = mock_model(User)
      @user_2 = mock_model(User)
      @users = [@user_1, @user_2]

      User.should_receive(:find).with(:all, :order => "lastname ASC").and_return(@users)
    end

    it "should expose all users as @users" do
      get :index
      assigns[:users].should == @users
    end

    describe "with mime type of xml" do

      it "should render all users as xml" do
        @user_1.should_receive(:summary_hash).and_return( {:n => 1} )
        @user_2.should_receive(:summary_hash).and_return( {:n => 2} )
        request.env["HTTP_ACCEPT"] = "application/xml"
        get :index
        response.body.should == "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<records type=\"array\">\n  " +
          "<record>\n    <n type=\"integer\">1</n>\n  </record>\n  <record>\n    " +
          "<n type=\"integer\">2</n>\n  </record>\n</records>\n"
      end

    end

    describe "with mime type of json" do

      it "should render flow cell summaries as json" do
        @user_1.should_receive(:summary_hash).and_return( {:n => 1} )
        @user_2.should_receive(:summary_hash).and_return( {:n => 2} )
        request.env["HTTP_ACCEPT"] = "application/json"
        get :index
        response.body.should == "[{\"n\": 1}, {\"n\": 2}]"
      end

    end

  end

  describe "responding to GET show" do

    describe "with mime type of xml" do

      it "should render the requested user as xml" do
        user = mock_model(User)
        user.should_receive(:detail_hash).and_return( {:n => 1} )

        request.env["HTTP_ACCEPT"] = "application/xml"
        User.should_receive(:find).with("37").and_return(user)
        get :show, :id => "37"
        response.body.should == "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<hash>\n  "+
          "<n type=\"integer\">1</n>\n</hash>\n"
      end

    end

    describe "with mime type of json" do

      it "should render the flow cell detail as json" do
        user = mock_model(User)
        user.should_receive(:detail_hash).and_return( {:n => 1} )

        request.env["HTTP_ACCEPT"] = "application/json"
        User.should_receive(:find).with("37").and_return(user)
        get :show, :id => 37
        response.body.should == "{\"n\": 1}"
      end

    end

  end

  describe "responding to PUT udpate" do

    def do_update
      put :update, :id => "37", :user => {:these => 'params'}, :user_profile => {:those => 'params'}
    end

    describe "with valid params" do

      before(:each) do
        User.stub!(:find).and_return(mock_user)
        mock_user.stub!(:load).and_return(true)
        mock_user.stub!(:save).and_return(true)
        mock_user.stub!(:user_profile).and_return(mock_user_profile)
        mock_user_profile.stub!(:update_attributes).and_return(true)
      end

      it "should find the user" do
        User.should_receive(:find).with("37").and_return(mock_user)
        do_update
      end

      it "should find the user profile" do
        mock_user.should_receive(:user_profile).and_return(mock_user_profile)
        do_update
      end

      it "should load the updates into the user" do
        mock_user.should_receive(:load).with({'these' => 'params'}).and_return(true)
        do_update
      end

      it "should save the user" do
        mock_user.should_receive(:save).and_return(true)
        do_update
      end

      it "should update the user profile" do
        mock_user_profile.should_receive(:update_attributes).
          with({'those' => 'params'}).and_return(true)
        do_update
      end

      it "should expose the requested user as @user" do
        do_update
        assigns(:user).should equal(mock_user)
      end

      it "should expose the user_profile as @user_profile" do
        do_update
        assigns(:user_profile).should equal(mock_user_profile) 
      end

      it "should redirect to the user" do
        do_update
        response.should redirect_to(users_url)
      end

    end

    describe "with invalid user params" do

      before(:each) do
        User.stub!(:find).and_return(mock_user)
        mock_user.stub!(:load).and_return(false)
        mock_user.stub!(:user_profile).and_return(mock_user_profile)
      end

      it "should update the requested user" do
        mock_user.should_receive(:load).with({'these' => 'params'})
        do_update
      end

      it "should expose the user as @user" do
        do_update
        assigns(:user).should equal(mock_user)
      end

      it "should expose the user_profile as @user_profile" do
        do_update
        assigns(:user_profile).should equal(mock_user_profile) 
      end

      it "should re-render the 'edit' template" do
        do_update
        response.should render_template('edit')
      end

    end

    describe "with valid user but invalid user profile params" do
      
      before(:each) do
        User.stub!(:find).and_return(mock_user)
        mock_user.stub!(:load).and_return(true)
        mock_user.stub!(:save).and_return(true)
        mock_user.stub!(:user_profile).and_return(mock_user_profile)
        mock_user_profile.stub!(:update_attributes).and_return(false)
      end
 
      it "should find the user" do
        User.should_receive(:find).with("37").and_return(mock_user)
        do_update
      end

      it "should find the user profile" do
        mock_user.should_receive(:user_profile).and_return(mock_user_profile)
        do_update
      end

      it "should load the updates into the user" do
        mock_user.should_receive(:load).with({'these' => 'params'}).and_return(true)
        do_update
      end

      it "should save the user" do
        mock_user.should_receive(:save).and_return(true)
        do_update
      end

      it "should fail to update the user profile" do
        mock_user_profile.should_receive(:update_attributes).
          with({'those' => 'params'}).and_return(false)
        do_update
      end

      it "should expose the user as @user" do
        do_update
        assigns(:user).should equal(mock_user)
      end

      it "should expose the user_profile as @user_profile" do
        do_update
        assigns(:user_profile).should equal(mock_user_profile) 
      end

      it "should re-render the 'edit' template" do
        do_update
        response.should render_template('edit')
      end

    end
  end 
end
