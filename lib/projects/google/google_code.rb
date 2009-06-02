require 'projects/google/google_code'

class GoogleCode
  def initialize(search_tag)
    @google_code_api = GoogleCodeApi.new()
    @search_tag = search_tag
  end

  ##
  ##  Executes a data scraping integrity test
  ##
  def test()
    # Search tag for test
    search_tag = "erlydtl"
    # All errors
    errors = []
    # Fetch the data for the google search (total available hits, etc)
    results = @google_code_api.spider(search_tag)
    # Check if we get any results from the main page
    if(results[:total_hits] == 0 || results[:total_pages] == 0)
       errors << self.class.name + ": No hits found (#{results[:total_hits]}) and no pages recorded (#{results[:total_pages]})"
    else
      # Let's grab the first page and ensure we have 10 entries
      results = @google_code_api.process_search_page(search_tag, 0)
      if(results.length != 1)
        errors << self.class.name + ": Could nor correctly parse the project in the search results"
      else
        # Fetch the project url and perform the tests
        url = results[0][:url]
        # Fetch the google data
        project_results = @google_code_api.parse_project(url)
        # Check that we got at least some results
        if(project_results[:downloads].length == 0)
          errors << self.class.name + ": Could nor correctly parse the project downloads feed"
        elsif(project_results[:updates].length == 0)
          errors << self.class.name + ": Could nor correctly parse the project updates feed"
        else
          # Fetch the first object
          project_downloads = project_results[:downloads][0]
          # Check if project has been parsed correctly
          if(project_downloads[:updated_at].nil? || project_downloads[:author].nil? || project_downloads[:title].nil? ||
                  project_downloads[:download_link].nil? || project_downloads[:hash_value].nil?)
            errors << self.class.name + ": Could nor correctly parse the project details: #{project_downloads.inspect}"
          end
          # Fetch the first object updates
          project_updates = project_results[:updates][0]
          # Check if project has been parsed correctly
          if(project_updates[:updated_at].nil? || project_updates[:author].nil? || project_updates[:title].nil? ||
                  project_updates[:download_link].nil? || project_updates[:hash_value].nil?)
            errors << self.class.name + ": Could nor correctly parse the project details: #{project_updates.inspect}"
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