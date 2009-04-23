class AddChannelBlogsTable < ActiveRecord::Migration
  def self.up
    create_table :channels_blogs do |t|
      t.integer     :channel_id, :null => false
      t.integer     :blog_id, :null => false      
      t.timestamps
    end
  end

  def self.down
    drop_table :channels_blogs
  end
end
