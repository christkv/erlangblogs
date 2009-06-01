require 'projects/slideshare/slide_share_api'

class SlideShare

  def initialize(api_key, secret, search_tag)
    @slide_share_api = SlideShareApi.new(api_key, secret)
    @search_tag = search_tag
  end

  ##
  ##  Executes a data scraping integrity test
  ##
  def test()
    # All errors
    errors = []
    # Check if we get any results
    results = @slide_share_api.get_slideshows_by_tag(@search_tag, 2, 0, 0)
    # filtered results by slideshow
    slide_shows = results.search("Slideshow")
    #puts results.methods.sort
    if(slide_shows.length > 0)
      # Fetch the slide_id
      slide_id = slide_shows[0].search("ID/text()").to_s
      slide_result = @slide_share_api.get_slideshow_information(slide_id)
      # Check if we got the correct result back
      if slide_result.search("ID/text()").to_s != slide_id
        errors << "Could not retrieve slideshow with id: #{slide_id}"        
      end
      # Let's try to grab the content from the presentation to check that it is working
      slide_url = slide_shows[0].search("URL/text()").to_s
      content = @slide_share_api.fetch_transcript(slide_url)
      if(content.length == 0)
        errors << "Could not retrieve content for url: #{slide_url}"        
      end
    elsif
      errors << "Could not retrieve any results with the search_tag: #{@search_tag}"
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