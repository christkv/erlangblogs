class CreateUserPlatforms < ActiveRecord::Migration
  def self.up
    create_table :user_platforms do |t|
      t.string      :login, :null => false
      t.string      :platform, :null => true
      t.string      :auth_token, :null => true
      t.string      :session, :null => true
      t.string      :email, :null => true
      t.text        :metadata, :null => true
      t.timestamps
    end
  end

  def self.down
    drop_table :user_platforms
  end
end
