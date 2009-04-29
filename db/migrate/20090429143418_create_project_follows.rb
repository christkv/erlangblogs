class CreateProjectFollows < ActiveRecord::Migration
  def self.up
    create_table :project_follows do |t|
      t.integer   :project_id, :null => false
      t.integer   :user_id, :null => false      
      t.timestamps
    end
  end

  def self.down
    drop_table :project_follows
  end
end
