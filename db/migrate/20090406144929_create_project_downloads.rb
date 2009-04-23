class CreateProjectDownloads < ActiveRecord::Migration
  def self.up
    #:project_id => project.id, :updated_at => updated_at, :author => author, :title => title, :url => download_link, :hash_value => md5_hash
    create_table :project_downloads do |t|
      t.integer     :project_id, :null => false
      t.datetime    :updated_at, :null => false
      t.string      :author, :null => true
      t.text        :title, :null => true
      t.text        :url, :null => true
      t.string      :hash_value, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :project_downloads
  end
end
