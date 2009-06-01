require 'scheduler_service'

namespace :scheduler do
  desc "Run Scheduler"
  task :run => :environment do
    slideshare_api_key = "FYJPY6bv"
    slideshare_secret = "5WBktthy"
    scheduler = SchedulerService.new({:slideshare_api_key => slideshare_api_key, :slideshare_secret => slideshare_secret, :search_tag => "erlang"})
    scheduler.start()
    scheduler.schedule()
    scheduler.join()
  end
end
