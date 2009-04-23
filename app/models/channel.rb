class Channel < ActiveRecord::Base
  has_and_belongs_to_many :blogs, :class_name => "Blog", :join_table => "channels_blogs"
  belongs_to :user  

  # Ferret indexing
  acts_as_ferret :fields => [:title, :description]  
end
