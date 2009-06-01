require 'projects/slideshare/slide_share'
require 'projects/github/github'
require 'projects/google/google_code'
require 'projects/sourceforge/source_forge'

class SchedulerService
  def initialize(hash_values)
    @hash_values = hash_values
  end

  def start()
    # Create a scheduler
    @backend_scheduler_api = BackendSchedulerApi.new("1s")
  end

  def schedule()
    # Add the wanted tasks to the scheduler
    slide_share_task = SlideShare.new(@hash_values[:slideshare_api_key], @hash_values[:slideshare_secret], @hash_values[:search_tag])
    google_code_task = GoogleCode.new(@hash_values[:search_tag])
    sourceforge_task = SourceForge.new(@hash_values[:search_tag])
    github_task = Github.new(@hash_values[:search_tag])
    # Register all the tasks
    #@backend_scheduler_api.add_task(slide_share_task, "60s")
    @backend_scheduler_api.add_task(google_code_task, "60s")
    #@backend_scheduler_api.add_task(sourceforge_task, "60s")
    #@backend_scheduler_api.add_task(github_task, "60s")
  end
  
  def join()
    # Join the scheduler thread
    @backend_scheduler_api.join()
  end
end