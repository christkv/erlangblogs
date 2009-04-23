class CreateProjects < ActiveRecord::Migration
  def self.up
    #:site => site, :url => project_url, :title => project_name, :description => project_description, :hash_value => md5_hash
    create_table :projects do |t|
      t.string      :site, :null => false
      t.text        :url, :null => false
      t.text        :title, :null => true
      t.text        :description, :null => true
      t.string      :hash_value, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :projects
  end
end
