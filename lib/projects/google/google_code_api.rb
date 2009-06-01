require 'nokogiri'
require 'open-uri'
require 'md5'

class GoogleCodeApi
  def spider(keyword, hits_pr_page = 10)
    # results
    results = {:total_hits => 0, :total_pages => 0}
    # Fetch the initial page
    initial_page = Nokogiri::HTML(open("http://code.google.com/hosting/search?q=#{keyword}&projectsearch=Search+projects"))
    # Fetch total /html/body/div[5]/table/tr/td/text()
    count_string = initial_page.search("/html/body/div[5]/table/tr/td/text()").to_s.scan(/[0-9]+/)
    if count_string.length == 3
      results[:total_hits] = count_string[2].to_i
      # Process the first page
      #process_search_page(initial_page)
      ## Calculat the number of pages
      results[:total_pages] = (results[:total_hits] / hits_pr_page) + 1
      #total_pages.times.each {|page|
      #  start_index = page * 10
      #  search_page = Nokogiri::HTML(open("http://code.google.com/hosting/search?q=#{keyword}&filter=1&start=#{start_index}"))
      #  # Process the page
      #  process_search_page(search_page)
      #}
    end
    # return the results
    return results
  end

  def process_search_page(keyword, page_number)
    results = []
    # Fetch the page
    initial_page = Nokogiri::HTML(open("http://code.google.com/hosting/search?q=#{keyword}&filter=1&start=#{page_number}"))
    # Now grab the descriptions in the current field
    all_divs = initial_page.search("//*[@id='serp']/div")
    0.step(all_divs.length - 1, 3) {|i|
      name_div = all_divs[i]
      description_div = all_divs[i + 1]
      label_div = all_divs[i + 2]
      project_name = name_div.search("a/text()").to_s
      project_url = name_div.search("a/@href").to_s
      project_description = description_div.search("text()").to_s
      project_categories = label_div.search("a/text()")
      # Set site
      site = "google_code"
      # Generate md5 code for this project
      md5_hash = MD5.md5("#{project_name}#{project_description}").to_s
      # Insert a project
      #project = Project.find(:first, :conditions => ["site = ? and url = ?", site, project_url])
      #puts "++++++++++++++++++++++++: #{project_name}"
      #if !project
      #  project = Project.create(:site => site, :url => project_url, :title => project_name, :description => project_description, :hash_value => md5_hash)
      #else
      #  project.update_attributes(:title => project_name, :description => project_description, :hash_value => md5_hash)
      #end
      # Pull the associated information
      #parse_project(project, name_div.search("a/@href"))
      results << {:site => site, :url => project_url, :title => project_name, :description => project_description, :hash_value => md5_hash}
    }
    # Return all the results found
    return results
  end

  def parse_project(url)
    project_update_url = "http://code.google.com/feeds#{url}updates/basic"
    downloads_url = "http://code.google.com/feeds#{url}downloads/basic"
    # fetch the project updates
    project_update_feed = SimpleRSS.parse open(project_update_url)
    # fetch the downloads
    downloads_feed = SimpleRSS.parse open(downloads_url)
    # Process all the download items
    downloads_feed.items.each {|item|
      #puts item.methods.sort
      updated_at = item.updated
      author = item.author.strip
      title = item.title.strip
      download_link = item.link.strip
      md5_hash = MD5.md5("#{title}#{download_link}").to_s
      # Check if this exists already
      #project_download = ProjectDownload.find(:first, :conditions => ["project_id = ? and hash_value = ?", project.id, md5_hash])
      #if !project_download
      #  ProjectDownload.create(:project_id => project.id, :updated_at => updated_at, :author => author, :title => title, :url => download_link, :hash_value => md5_hash)
      #end
    }
    # Process all the project update items
    project_update_feed.items.each {|item|
      #puts item.methods.sort
      updated_at = item.updated
      author = item.author.strip
      title = item.title.strip
      download_link = item.link.strip
      md5_hash = MD5.md5("#{title}#{download_link}").to_s
      # Check if this exists already
      #project_update = ProjectUpdate.find(:first, :conditions => ["project_id = ? and hash_value = ?", project.id, md5_hash])
      #if !project_update
      #  ProjectUpdate.create(:project_id => project.id, :updated_at => updated_at, :author => author, :title => title, :url => download_link, :hash_value => md5_hash)
      #end
    }
  end
end








