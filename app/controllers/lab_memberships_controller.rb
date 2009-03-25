class LabMembershipsController < ApplicationController
  include AuthenticatedSystem

  # GET /lab_memberships
  # GET /lab_memberships.xml
  def index
    @user = User.find(params[:user_id])
    @lab_memberships = @user.lab_memberships

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @lab_memberships }
    end
  end

  # GET /lab_memberships/new
  # GET /lab_memberships/new.xml
  def new
    @user = User.find(params[:user_id])
    @lab_membership = LabMembership.new(
      :user_id => @user.id,
      :lab_group_id => nil
    )

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @lab_membership }
    end
  end

  # GET /lab_memberships/1/edit
  def edit
    @lab_membership = LabMembership.find(params[:id])
    @user = @lab_membership.user
  end

  # POST /lab_memberships
  # POST /lab_memberships.xml
  def create
    @lab_membership = LabMembership.new(params[:lab_membership])
    @user = @lab_membership.user

    respond_to do |format|
      if @lab_membership.save
        flash[:notice] = 'LabMembership was successfully created.'
        format.html { redirect_to( user_lab_memberships_path(@user) ) }
        format.xml  { render :xml => @lab_membership, :status => :created, :location => @lab_membership }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @lab_membership.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /lab_memberships/1
  # PUT /lab_memberships/1.xml
  def update
    @lab_membership = LabMembership.find(params[:id])
    @user = @lab_membership.user

    respond_to do |format|
      if @lab_membership.load(params[:lab_membership]) && @lab_membership.save
        flash[:notice] = 'LabMembership was successfully updated.'
        format.html { redirect_to( user_lab_memberships_path(@user) ) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @lab_membership.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /lab_memberships/1
  # DELETE /lab_memberships/1.xml
  def destroy
    @lab_membership = LabMembership.find(params[:id])
    @user = @lab_membership.user
    @lab_membership.destroy

    respond_to do |format|
      format.html { redirect_to( user_lab_memberships_path(@user) ) }
      format.xml  { head :ok }
    end
  end

end
