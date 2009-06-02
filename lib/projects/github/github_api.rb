require 'open-uri'
require 'md5'
require 'nokogiri'

class GithubApi
  def spider(keyword)
    # Fetch the initial page
    initial_page = Nokogiri::HTML(open("http://github.com/search?langOverride=&language=&q=#{keyword}&repo=&start_value=1&type=Repositories&x=22&y=23"))
    number_of_pages = initial_page.search("div[@class='pagination']/a[@class='pager_link']/text()").to_a.reverse[0].to_s.to_i
    number_of_hits = initial_page.search("div[@class='title']/text()").to_s.match(/\d+/).to_s.to_i
    puts "---------- Number of pages: #{number_of_pages}"
    # results
    results = {:total_hits => number_of_hits, :total_pages => number_of_pages}
    #begin
      # Process the initial page
    #  process_page(initial_page)
    #rescue Exception => e
    #  puts e.backtrace
    #end
    # Process all the remainding pages
    #2.step((number_of_pages + 1), 1) {|i|
    #  begin
    #    puts "==================================================================================================================================="
    #    puts "========== Process http://github.com/search?langOverride=&language=&q=erlang&repo=&start_value=#{i}&type=Repositories&x=22&y=23"
    #    puts "==================================================================================================================================="
    #    page = Nokogiri::HTML(open("http://github.com/search?langOverride=&language=&q=erlang&repo=&start_value=#{i}&type=Repositories&x=22&y=23"))
    #    process_page(page)
    #  rescue Exception => e
    #    puts e.backtrace
    #  end
    #}
    return results
  end

  def process_page(keyword, page_number)
    # Project results returned
    projects = []
    # Fetch the page
    page = Nokogiri::HTML(open("http://github.com/search?langOverride=&language=&q=#{keyword}&repo=&start_value=#{page_number}&type=Repositories&x=22&y=23"))    
    # Parse all the pages
    page.search("div[@class='result']").each {|project_result|
      author = project_result.search("h2[@class='title']/a/@href").to_s.split(/\//).reject {|x| "".eql?(x) }
      description = project_result.search("div[@class='description']/text()").to_s
      url = project_result.search("h2[@class='title']/a/@href").to_s
      project_md5_hash = MD5.md5("#{author}#{description}#{url}").to_s
      puts "++++++++++++++++++++++++++++++++++++++++++++++++++++++"
      puts "  url: #{url}"
      puts "  author: #{author}"
      puts "  description: #{description}"
      puts "------------------------------------------------------"

      # Generate urls for project
      project_url = "http://github.com#{url}"      
      commits_url = "#{project_url}commits"
      downloads_url = "#{project_url}downloads"
      # Fetch the project_url
      #project_page = agent.get(project_url)
      project_page = Nokogiri::HTML(open(project_url))
      # Fetch readme metadata for project page
      metadata = {:readme => project_page.search("div[@id='readme']//pre/text()").to_s, :rank => project_page.search("div[@class='flexipill']/[2]//tr//span")[1].search("text()").to_s}.to_yaml
      # Set site
      site = "github"
      # Insert a project
      #project = Project.find(:first, :conditions => ["site = ? and url = ?", site, url])
      #if !project
      #  project = Project.create(:site => site, :url => url, :title => description, :description => description, :metadata => metadata, :hash_value => project_md5_hash)
      #else
      #  project.update_attributes(:site => site, :title => description, :description => description, :metadata => metadata, :hash_value => project_md5_hash)
      #end

      # Create a project object
      project = {:author => author, :description => description, :url => url, :metadata => metadata, :hash_value => project_md5_hash, :updates => [], :downloads => []}

      # Fetch commits page and details
      #commits_page = agent.get(commits_url)
      commits_page = open(commits_url) {|f| Hpricot(f)}
      commits = commits_page.search("div[@id='commit']/div")
      0.step(commits.length - 1, 2) {|i|
        date_div = commits[i]
        commits_div = commits[i + 1]
        # Retrieve the date information
        updated_at = date_div.search("h2/text()").to_s
        # Retrieve the commits
        commits_div.search("div[@class='human']").each {|commit|
          commit_message = commit.search("div[@class='message']//a/text()")
          commit_author = commit.search("div[@class='actor']/div[@class='name']//a/text()").to_s
          commit_md5_hash = MD5.md5("#{updated_at}#{commit_author}#{commit_message}").to_s
          # Check if this exists already
          #project_update = ProjectUpdate.find(:first, :conditions => ["project_id = ? and hash_value = ?", project.id, commit_md5_hash])
          #if !project_update.nil?
          #  ProjectUpdate.create(:project_id => project.id, :updated_at => updated_at, :author => author, :title => commit_message, :url => "", :hash_value => commit_md5_hash)
          #end

          project[:updates] << {:author => commit_author, :updated_at => updated_at, :title => commit_message, :download_link => "", :hash_value => commit_md5_hash}

          puts "  Commit #{updated_at},#{commit_message},#{commit_author}"
        }
      }
      # Fetch available downloads
      #downloads_page = agent.get(downloads_url)
      downloads_page = Nokogiri::HTML(open(downloads_url))
      downloads = downloads_page.search("div[@id='downloads']/div/table[2]//tr")
      1.step(downloads.length - 1, 1) {|i|
        # Get row
        download_row = downloads[i]
        # Unpack variables
        version = download_row.search("td[2]/text()").to_s
        url = download_row.search("td[3]/a/@href").to_s
        description = download_row.search("td[4]/text()").to_s
        updated_at = download_row.search("td[5]/text()").to_s
        download_md5_hash = MD5.md5("#{version}#{url}#{description}").to_s
        # Check if this exists already
        #project_download = ProjectDownload.find(:first, :conditions => ["project_id = ? and hash_value = ?", project.id, download_md5_hash])
        #if !project_download.nil?
        #  ProjectDownload.create(:project_id => project.id, :updated_at => updated_at, :author => author, :title => description, :url => url, :hash_value => download_md5_hash)
        #end
        project[:downloads] << {:author => "", :updated_at => updated_at, :title => description, :download_link => url, :hash_value => download_md5_hash, :version => version}

        puts "  Download #{version},#{url},#{description}"
      }

      # Add the project to the project list
      projects << project
    }
    # Return all the projects
    return projects
  end
end