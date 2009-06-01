require 'projects/google/google_code_api'

class ProjectsFetchWorker < Workling::Base

  def fetch_projects(options)
    begin
      keywords = params[:keywords]
      

    rescue Exception => e
      puts e.backtrace
    end
  end
end