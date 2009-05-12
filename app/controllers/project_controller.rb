class ProjectController < ApplicationController
  sortable_attributes :title

  def index()
    @projects = Project.paginate(:page => params[:page], :per_page => 10, :order => "title asc")
    @most_active_projects = Project.most_active_projects(31, 5)
    # If we have some projects let's set up the first project
    if @most_active_projects.length > 0
      @project = @most_active_projects.first
      @project_updates = ProjectUpdate.find(:all, :conditions => ["project_id = ?", @project.id], :order => "updated_at desc", :limit => 3)
      @project_download = ProjectDownload.find(:first, :conditions => ["project_id = ?", @project.id], :order => "updated_at desc")
    end
  end

  def show()
    @project = Project.find(:first, :conditions => ["id = ?", params[:id]])
    @project_update = ProjectUpdate.find(:all, :conditions => ["project_id = ?", @project.id]).paginate(:page => params[:page], :per_page => 5, :order => "updated_at desc")
    @project_downloads = ProjectDownload.find(:all, :conditions => ["project_id = ?", @project.id]).paginate(:page => params[:page], :per_page => 5, :order => "updated_at desc")
  end

  ##
  ##
  ##
  def info()
    project= Project.find(:first, :conditions => ["id = ?", params[:id]])
    project_updates = ProjectUpdate.find(:all, :conditions => ["project_id = ?", project.id], :order => "updated_at desc", :limit => 3)
    project_download = ProjectDownload.find(:first, :conditions => ["project_id = ?", project.id], :order => "updated_at desc")
    render :partial => 'project_short_info', :locals => {:project => project, :project_updates => project_updates, :project_download => project_download}
  end

  ##
  ##  Allows the following of a project for a give user
  ##
  def follow()
    project = Project.find(:first, :conditions => ["id = ?", params[:id]])
    if !current_user.nil?
      current_user.project_follows.push(project)
      current_user.save()
    end
    render :partial => "follow", :locals => {:text => "Remove", :mode => "remove", :project_id => project.id}
  end

  ##
  ##  Remove a project follow for a user
  ##
  def remove_follow()
    project = Project.find(:first, :conditions => ["id = ?", params[:id]])
    if !current_user.nil?
      current_user.project_follows.delete(project)
      current_user.save()
    end
    render :partial => "follow", :locals => {:text => "Follow", :mode => "follow", :project_id => project.id}
  end
end
