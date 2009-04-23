class CreateProjectUpdates < ActiveRecord::Migration
  def self.up
    create_table :project_updates do |t|
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
    drop_table :project_updates
  end
end
