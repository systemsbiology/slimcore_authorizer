=begin rapidoc
name:: /lab_groups

This resource can be used to list a summary of all lab_groups, or show details for
a particular lab_group.<br><br>

A lab_group can have and belong to users.
=end

class LabGroupsController < ApplicationController
  before_filter :login_required
  before_filter :staff_or_admin_required

=begin rapidoc
url:: /lab_groups
method:: GET
example:: <%= SiteConfig.site_url %>/lab_groups
access:: HTTP Basic authentication, Customer access or higher
json:: <%= JsonPrinter.render(LabGroup.find(:all, :limit => 5).collect{|x| x.summary_hash}) %>
xml:: <%= LabGroup.find(:all, :limit => 5).collect{|x| x.summary_hash}.to_xml %>
return:: A list of all summary information on all lab_groups

Get a list of all lab_groups, which doesn't have all the details that are
available when retrieving single lab_groups (see GET /lab_groups/[lab_group id]).
=end

  def index
    @lab_groups = LabGroup.find(:all, :order => "name ASC")

    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @lab_groups.
        collect{|x| x.summary_hash}
      }
      format.json { render :json => @lab_groups.
        collect{|x| x.summary_hash}.to_json
      }
    end
  end

=begin rapidoc
url:: /lab_groups/[lab_group id]
method:: GET
example:: <%= SiteConfig.site_url %>/lab_groups/5.json
access:: HTTP Basic authentication, Customer access or higher
json:: <%= JsonPrinter.render(LabGroup.find(:first).detail_hash) %>
xml:: <%= LabGroup.find(:first).detail_hash.to_xml %>
return:: Detailed attributes of a particular lab_group

Get detailed information about a single lab_group.
=end

  def show
    @lab_group = LabGroup.find(params[:id])

    respond_to do |format|
      format.xml  { render :xml => @lab_group.detail_hash }
      format.json  { render :json => @lab_group.detail_hash }
    end
  end

  def new
    @lab_group = LabGroup.new(
      :name => "",
      :lock_version => 0
    )
  end

  def create
    @lab_group = LabGroup.new(params[:lab_group])
    @lab_group_profile = LabGroupProfile.new(params[:lab_group_profile])

    if @lab_group.valid?
      @lab_group.save
      @lab_group_profile.lab_group_id = @lab_group.id
      @lab_group_profile.save

      flash[:notice] = 'LabGroup was successfully created.'
      redirect_to lab_groups_url
    else
      render :action => 'new'
    end
  end

  def edit
    @lab_group = LabGroup.find(params[:id])
    @lab_group_profile = @lab_group.lab_group_profile
  end

  def update
    @lab_group = LabGroup.find(params[:id])
    @lab_group_profile = @lab_group.lab_group_profile

    begin
      if @lab_group.load(params[:lab_group]) && @lab_group.save &&
         @lab_group_profile.update_attributes(params[:lab_group_profile])
        flash[:notice] = 'LabGroup was successfully updated.'
        redirect_to lab_groups_url
      else
        render :action => 'edit'
      end
    rescue ActiveRecord::StaleObjectError
      flash[:warning] = "Unable to update information. Another lab_group has modified this lab group."
      @lab_group = LabGroup.find(params[:id])
      render :action => 'edit'
    end
  end

  def destroy
    begin
      LabGroup.find(params[:id]).destroy
      redirect_to lab_groups_url
    rescue
      flash[:warning] = "Cannot delete lab group due to association " +
                        "with chip transactions or hybridizations."
      redirect_to lab_groups_url
    end
  end
end
