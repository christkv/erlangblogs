class ProjectController < ApplicationController
  sortable_attributes :title

  def index()
    params["order"] = "ascending"
    #@projects = Project.paginate(:page => params[:page], :per_page => 20, :order => sort_order())
    @projects = Project.paginate(:page => params[:page], :per_page => 30, :order => "title asc")
  end

  def show()
    
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
