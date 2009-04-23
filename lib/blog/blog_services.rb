class BlogServices
  ## Blog
  ##  t.integer   :user_id, :null => false
  ##  t.string    :title, :null => false
  ##  t.text      :description, :null => false
  ##  t.text      :url, :null => false
  ##  t.text      :feed_url, :null => false
  ##  t.text      :metadata, :null => true
  def add_blog(user_id, title, description, url, feed_url, metadata)
    # validate if blog exists allready
    blog = Blog.find(:first, :conditions => ["feed_url = ?", feed_url])
    if blog.nil?
      blog = Blog.create(:user_id => user_id, :title => title, :description => description,
        :url => url, :feed_url => url, :metadata => metadata.to_json)
    end
    # Return blog
    return blog
  end

  ##
  ## Remove an existing blog for a specific user
  ##
  def remove_blog(user_id, feed_url)
    # fetch the blog if it exists
    blog = Blog.find(:first, :conditions => ["feed_url = ?", feed_url])
    if !blog.nil?
      # Delete all the blog entries
      blog.blog_entries.delete_all()
      # Delete all the blog channel entries
      blog.channels.delete_all()
      # Remove blog, related channels and entries
      blog.delete()
    end
  end

  ##
  ##  Retrive a users blogs
  ##
  def retrive_blogs(user_id)
    return Blog.find(:all, :conditions => ["user_id = ?", user_id])
  end

  ##
  ##  Trigger fetching and synching of blogs using async operation with workling
  ##
  def sync_blog(feed_url)
    # Check if there is an existing blog for this channel
    BlogFetchFeedWorker.asynch_update_feed({:feed_url => feed_url})
  end

  def sync_user_blog(user_id, feed_url)
    BlogFetchFeedWorker.asynch_update_feed({:user_id => user_id, :feed_url => feed_url})
  end

  ##
  ## Search functionalities
  ##
  def search_blogs(query)
    Blog.find_with_ferret(query)
  end

  def search_blog_entries(query)
    BlogEntry.find_with_ferret(query)
  end

  def search_channels(query)
    Channel.find_with_ferret(query)
  end

  ##
  ## Add a blog to a channel
  ##
  def add_blog_to_channel(blog_id, channel_id)
    # Validate that the connection does not already exist
    blog_channel = BlogChannel.find(:first, :conditions => ["blog_id = ? and channel_id = ?", blog_id, channel_id])
    if !blog_channel
      BlogChannel.create(:blog_id => blog_id, :channel_id => channel_id)
    end
  end

  def add_blogs_to_channel(blog_ids, channel_id)
    if(blog_ids.length > 0)
      blog_ids.each {|blog_id|
        add_blog_to_channel(blog_id, channel_id)
      }
    end
  end

  def remove_blog_from_channel(blog_id, channel_id)
    blog_channel = BlogChannel.find(:first, :conditions => ["blog_id = ? and channel_id = ?", blog_id, channel_id])
    if blog_channel
      blog_channel.delete()
    end
  end

  ##
  ## Retrive all the channels of a user
  ##
  def retrieve_channels(user_id)
    return Channel.find(:all, :conditions => ["user_id = ?", user_id])
  end

  ##
  ##  Retrive all the blogs of a user sorted by updated_at date
  ##
  def retrieve_all_channel_blogs(user_id)
    blogs = []
    channel_ids = Channel.find(:all, :conditions => ["user_id = ?", user_id]).map(&:id)
    if(channel_ids.length() > 0)
      blog_ids = ChannelBlog.find(:all, :conditions => ["channel in (?)", channel_ids.join(",")]).map(&:blog_id)
      if(blog_ids.length() > 0)
        blogs = Blog.find(:all, :conditions => ["id in (?)", blog_ids.join(",")])
      end
    end  
    # Return all the blogs
    return blogs
  end  
end
































