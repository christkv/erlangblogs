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