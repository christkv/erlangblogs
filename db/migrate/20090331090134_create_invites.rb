class CreateInvites < ActiveRecord::Migration
  def self.up
    create_table :invites do |t|
      t.column :user_id,  :integer, :null => false
      t.column :user_id_target,   :integer, :null => false
      t.column :message, :text
      t.column :is_accepted, :boolean
      t.timestamps
    end
  end

  def self.down
    drop_table :invites
  end
end
