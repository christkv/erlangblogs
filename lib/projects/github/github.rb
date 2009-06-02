require 'projects/github/github_api'

class Github
  def initialize(search_tag)
    @github_api = GithubApi.new()
    @search_tag = search_tag
  end

  ##
  ##  Executes a data scraping integrity test
  ##
  def test()
    # Search tag for the test
    search_tag = "herml"
    # All errors
    errors = []
    # Get the spidering results
    results = @github_api.spider(search_tag)
    # Check if we have any errors
    if(results[:total_hits] == 0 && results[:total_pages] == 0)
      errors << self.class.name + ": No hits found (#{results[:total_hits]}) and no pages recorded (#{results[:total_pages]})"
    else
      # Ok let's fetch the first project (should be heml)
      projects = @github_api.process_page(search_tag, 1)
      if(projects.length == 0)
        errors << self.class.name + ": No projects correctly parsed"
      else
        # get the first project
        project = projects[0]
        # Check if the project is correct
        #project = {:author => author, :description => description, :url => url, :metadata => metadata, :hash_value => project_md5_hash, :updates => [], :downloads => []}
        if(project[:author].nil? || project[:description].nil? || project[:url].nil? || project[:metadata].nil? || project[:hash_value].nil? || project[:updates].length == 0 || project[:downloads].length == 0)
          errors << self.class.name + ": Project not being parsed correctly (including possibly updates/downloads)"
        else
          update = project[:updates][0]
          download  = project[:downloads][0]
          # Check each of these
          #{:author => commit_author, :updated_at => updated_at, :title => commit_message, :download_link => "", :hash_value => commit_md5_hash}
          if(update[:author].nil? || update[:updated_at].nil? || update[:title].nil? || update[:download_link].nil? || update[:hash_value].nil?)
            errors << self.class.name + ": Project Update not being parsed correctly"
          end

          #{:author => "", :updated_at => updated_at, :title => description, :download_link => url, :hash_value => download_md5_hash, :version => version}
          if(download[:author].nil? || download[:updated_at].nil? || download[:title].nil? || download[:download_link].nil? || download[:hash_value].nil? || download[:version].nil?)
            errors << self.class.name + ": Project Download not being parsed correctly"                        
          end
        end
      end
    end
    # Return all the errors
    return errors
  end

  ##
  ##  Execute actualy scraping of information
  ##
  def execute()

  end
end