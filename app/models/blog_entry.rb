class BlogEntry < ActiveRecord::Base
  acts_as_taggable

  belongs_to :blog

  # Ferret indexing
  acts_as_ferret :fields => [:title, :content, :url]
end
