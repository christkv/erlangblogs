class ChannelBlog < ActiveRecord::Base
  set_table_name "channels_blogs"

  belongs_to :blog
  belongs_to :channel  
end
