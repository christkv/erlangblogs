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
    # Return all the errors
    return errors
  end

  ##
  ##  Execute actualy scraping of information
  ##
  def execute()

  end
end