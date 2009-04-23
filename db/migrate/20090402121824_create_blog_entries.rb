class CreateBlogEntries < ActiveRecord::Migration
  def self.up
    create_table :blog_entries do |t|
      t.integer   :blog_id, :null => false
      t.string    :title, :null => false
      t.text      :content, :null => false
      t.text      :url, :null => false
      t.datetime  :date_published, :null => false
      t.text      :metadata, :null => true
      t.string    :hash_value, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :blog_entries
  end
end
