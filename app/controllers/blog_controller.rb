class BlogController < ApplicationController

  def index
    @blog_entries = BlogEntry.paginate(:page => params[:page], :per_page => 20, :order => "date_published asc")
  end
end
