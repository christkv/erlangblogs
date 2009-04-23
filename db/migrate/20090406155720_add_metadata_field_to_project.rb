class AddMetadataFieldToProject < ActiveRecord::Migration

  def self.up
    add_column :projects, :metadata, :text, :null => true
  end

  def self.down
    remove_column :projects, :metadata
  end
end
