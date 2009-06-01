require 'projects/sourceforge/source_forge_api'

class SourceForge
  def initialize(search_tag)
    @source_forge_api = SourceForgeApi.new()
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