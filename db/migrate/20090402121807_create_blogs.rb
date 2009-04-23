class CreateBlogs < ActiveRecord::Migration
  def self.up
    create_table :blogs do |t|
      t.integer   :user_id, :null => false
      t.string    :title, :null => false
      t.text      :description, :null => false
      t.text      :url, :null => false
      t.text      :feed_url, :null => false
      t.datetime  :last_updated, :null => false
      t.text      :metadata, :null => true
      t.timestamps
    end
  end

  def self.down
    drop_table :blogs
  end
end
