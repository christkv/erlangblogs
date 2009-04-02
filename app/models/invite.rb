class Invite < ActiveRecord::Base
  #t.integer  "user_id",        :null => false
  #t.integer  "user_id_target", :null => false
  #t.text     "message"
  #t.boolean  "is_accepted"
  #t.datetime "created_at"
  #t.datetime "updated_at"
  def self.invite(user, target_user, message)
    return Invite.create({:user_id => user.id, :user_id_target => target_user.id, :message => message})
  end

  def self.accept!(user, user_target)
    invite = Invite.find(:first, :conditions => ["user_id = ? and user_id_target = ?", user.id, target_user.id])
    invite.is_accepted = true
    invite.save()
  end

  def self.reject!(user, user_target)
    invite = Invite.find(:first, :conditions => ["user_id = ? and user_id_target = ?", user.id, target_user.id])
    invite.is_accepted = false
    invite.save()
  end

  def self.delete!(user, user_target)
    invite = Invite.find(:first, :conditions => ["user_id = ? and user_id_target = ?", user.id, target_user.id])
    invite.delete()
  end
end
