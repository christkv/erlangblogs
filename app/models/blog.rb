class Blog < ActiveRecord::Base
  acts_as_taggable

  has_many :blog_entries
  has_and_belongs_to_many :channels, :class_name => "Channel", :join_table => "channels_blogs"  
  belongs_to :user

  # Ferret indexing
  acts_as_ferret :fields => [:title, :description, :url, :feed_url]  
end
