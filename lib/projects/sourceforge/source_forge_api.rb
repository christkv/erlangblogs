require 'open-uri'
require 'md5'
require 'nokogiri'

class SourceForgeApi
  def spider(keywords)
    hits_pr_page = 10
    # fetch inital page
    inital_page = Nokogiri::HTML(open("http://sourceforge.net/search/?words=erlang&sort=score&sortdir=desc&offset=0&type_of_search=soft&pmode=0"))
    # fetch the number of pages available
    number_of_pages = inital_page.search("/html/body/div/div[2]/div[2]/table/tfoot/tr/td/form/a[3]/text()").to_s.to_i
    number_of_pages.times.each {|page_number|
      offset = page_number * 10
      page = Nokogiri::HTML(open("http://sourceforge.net/search/?words=erlang&sort=score&sortdir=desc&offset=#{offset}&type_of_search=soft&pmode=0"))
      process_search_page(page)
      #break
    }
  end

  def process_search_page(page)
    # set owning site
    site = "sourceforge"
    # fetch each project
    projects = page.search("/html/body/div/div[2]/div[2]/table/tbody")
    puts "+++++++++++++++++++++++++ #{projects.class.to_s}"
    # parse each project
    projects.each {|project|
      begin
        title = project.search("td[@class='project']/h2/a/text()").to_s.strip
        url = project.search("td[@class='project']/h2/a/@href").to_s
        description = project.search("td[@class='description']/text()").to_s.strip
        tags = project.search("td[@class='description']/ul/li[@class='show']/a/text()").map{|x| x.to_s}.join(",")
        activity = project.search("td[3]/text()").to_s.strip
        rank = project.search("td[4]/h3/a/text()").to_s.strip
        registered = project.search("td[5]/text()").to_s.strip
        downloads = project.search("td[7]/text()").to_s.strip
        if title.length > 0
          puts "--------------------------------------------------------------------------------------------------------"
          puts "-- #{url}"
          puts "-- #{title}"
          puts "-- #{description}"
          puts "-- #{tags}"
          puts "-- #{activity}"
          puts "-- #{rank}"
          puts "-- #{registered}"
          puts "-- #{downloads}"
          # Generate md5 code for this project
          md5_hash = MD5.md5("#{title}#{description}").to_s
          # Check if the project exits, create it or updateit
          project = Project.find(:first, :conditions => ["site = ? and url = ?", site, url])
          if !project
            project = Project.create(:site => site, :url => url, :title => title, :description => description, :hash_value => md5_hash)
          else
            project.update_attributes(:title => title, :description => description, :hash_value => md5_hash)
          end
          # fetch the main project page
          main_page = Nokogiri::HTML(open("http://sourceforge.net#{url}"))
          rss_url = main_page.search("small[@class='rss']/a/@href").to_s
          #decompose the url into pieces to grab group id
          group_id = rss_url.split(/\=/)[1]
          # rss feeds
          recent_activity_rss_url = "http://sourceforge.net/export/rss2_keepsake.php?group_id=#{group_id}"
          project_file_releases_rss_url = "http://sourceforge.net/export/rss2_projfiles.php?group_id=#{group_id}"
          # fetch feeds
          recent_activity_feed = SimpleRSS.parse open(recent_activity_rss_url)
          project_file_feed = SimpleRSS.parse open(project_file_releases_rss_url)
          # parse feeds
          puts "    ------------------------------ Recent Activities ----"
          recent_activity_feed.items.each {|item|
            title = item.title
            description = item.description
            author = item.author
            link = item.link
            publish_date = item.pubDate
            puts "    -- #{title}"
            puts "    -- #{description}"
            puts "    -- #{author}"
            puts "    -- #{link}"
            puts "    -- #{publish_date}"
            # genereate md5 hash for entry
            md5_hash = MD5.md5("#{title}#{link}").to_s
            # Check if this exists already
            project_update = ProjectUpdate.find(:first, :conditions => ["project_id = ? and hash_value = ?", project.id, md5_hash])
            if !project_update
              ProjectUpdate.create(:project_id => project.id, :updated_at => publish_date, :author => author, :title => title, :url => link, :hash_value => md5_hash)
            end
          }

          # parse feeds
          puts "    ------------------------------ Project files ----"
          project_file_feed.items.each {|item|
            title = item.title
            description = item.description
            author = item.author
            link = item.link
            publish_date = item.pubDate
            puts "    -- #{title}"
            puts "    -- #{description}"
            puts "    -- #{author}"
            puts "    -- #{link}"
            puts "    -- #{publish_date}"
            # genereate md5 hash for entry
            md5_hash = MD5.md5("#{title}#{link}").to_s
            # Check if this exists already
            project_download = ProjectDownload.find(:first, :conditions => ["project_id = ? and hash_value = ?", project.id, md5_hash])
            if !project_download
              ProjectDownload.create(:project_id => project.id, :updated_at => publish_date, :author => author, :title => title, :url => link, :hash_value => md5_hash)
            end
          }
        end
      rescue Exception => e
        puts e.backtrace
      end  
    }
  end
end