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
    # All errors
    errors = []
    # Fetch the data for the google search (total available hits, etc)
    results = @google_code_api.spider(@search_tag)
    # Check if we get any results from the main page
    if(results[:total_hits] == 0 || results[:total_pages] == 0)
       errors << "No hits found (#{results[:total_hits]}) and no pages recorded (#{results[:total_pages]})"
    else
      # Let's grab the first page and ensure we have 10 entries
      results = @google_code_api.process_search_page(@search_tag, 0)
      if(results.length != 10)
        errors << "Could nor correctly parse the 10 results in the search"
      else
        # Fetch the project url and perform the tests
        url = results[0][:url]
        # Fetch the google data
        project_results = @google_code_api.parse_project(url)
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