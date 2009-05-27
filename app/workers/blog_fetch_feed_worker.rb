require 'hpricot'
require 'open-uri'
require 'feed-normalizer'
require 'md5'

class BlogFetchFeedWorker < Workling::Base
  #      t.integer   :blog_id, :null => false
  #      t.string    :content, :null => false
  #      t.text      :description, :null => false
  #      t.text      :url, :null => false
  #      t.text      :feed_url, :null => false
  #      t.text      :metadata, :null => true
  #      t.string    :hash_value, :null => false
  #      t.timestamps    
  def update_feed(options)
    begin
      # Log blog retrival
      puts "BlogFetchFeedWorker: #{options.inspect}"
      # unpack parameters
      feed_url = options[:feed_url]
      user_id = !options[:user_id].nil? ? options[:user_id] : 0
      # fetch the feed content
      feed_content = Hpricot(open(feed_url)).to_s
      # Parse using feed normalizer
      feed = FeedNormalizer::FeedNormalizer.parse(feed_content)
      if feed
        # Fetch all feed items
        feed_items = feed.items
        feed.items = []
        # Check if we have an existing blog item (and update this if it's the case
        blog = Blog.find(:first, :conditions => ["feed_url = ?", feed_url])
        if blog
          # Update the blog data if any
          blog.update_attributes(:url => feed.url, :title => feed.title, :description => feed.description, :metadata => feed.to_yaml(), :last_updated => feed.last_updated)
        else
          blog = Blog.create(:feed_url => feed_url, :user_id => user_id, :url => feed.url, :title => feed.title, :description => feed.description,
            :metadata => feed.to_yaml(), :last_updated => feed.last_updated)
        end
        # Let's iterate over all the items and insert them into the blog entries table if applicable
        feed_items.each {|feed_item|
          # Validate that item does not already exist in the db (using content hash md5 including title+content)
          md5_hash = MD5.md5("#{feed_item.title}#{feed_item.description}").to_s
          blog_entry = BlogEntry.find(:first, :conditions => ["hash_value = ?", md5_hash])
          if !blog_entry
            content = feed_item.description
            feed_item.content = ""
            blog_entry = BlogEntry.create(:blog_id => blog.id, :title => feed_item.title, :content => content, :url => feed_item.urls.join(","),
              :date_published => feed_item.date_published, :metadata => feed_item.to_yaml(), :hash_value => md5_hash)
          end
        }
      end
    rescue Exception => e
      puts e.backtrace
    end
  end
end
