class CreateChannels < ActiveRecord::Migration
  def self.up
    create_table :channels do |t|
      t.string      :title, :null => false
      t.text        :description, :null => true
      t.integer     :user_id, :null => true
      t.timestamps
    end
  end

  def self.down
    drop_table :channels
  end
end
