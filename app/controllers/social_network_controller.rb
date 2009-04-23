class SocialNetworkController < ApplicationController
  before_filter :require_user, :only => [:list, :invite, :accept, :reject, :remove]

  def list()
    user_id = params[:id]
    # Fetch the user
    user = User.find(:first, :conditions => ["id = ?", user_id])
    # Fetch the friends
    @friends = user.friends
  end

  def invite()
    user_id = params[:id]
    user_id_target = params[:user_id_target]
    # Fetch the user
    user = User.find(:first, :conditions => ["id = ?", user_id])
    user_target = User.find(:first, :conditions => ["id = ?", user_id_target])
    # Invitation message
    message = "User #{user.firstname} #{user.lastname} invited you to be his friend"
    # Check if there is an existing invitation
    if !user.friends.include?(user_target)
      #Invite friend and flash invitation correctly sent
      Invite.invite(user, user_target, message)
      flash[:notice] = "Invited user"
    else
      flash[:error] = "User already invited"
    end
  end

  def accept()
    user_id = params[:id]
    user_id_target = params[:user_id_target]
    # Fetch the user
    user = User.find(:first, :conditions => ["id = ?", user_id])
    user_target = User.find(:first, :conditions => ["id = ?", user_id_target])
    # Locate invitation
    if !user.friends.include?(user_target)
      invite = Invite.accept!(user, user_target)
      flash[:notice] = "Invite accepted"
    else
      flash[:error] = "Users already friends"
    end
  end

  def reject()
    user_id = params[:id]
    user_id_target = params[:user_id_target]
    # Fetch the user
    user = User.find(:first, :conditions => ["id = ?", user_id])
    user_target = User.find(:first, :conditions => ["id = ?", user_id_target])
    # Locate invitation
    if user.friends.include?(user_target)
      invite = Invite.reject!(user, user_target)
      flash[:notice] = "Invite rejected"
    else
      flash[:error] = "Users already friends"
    end
  end

  def remove()
    user_id = params[:id]
    user_id_target = params[:user_id_target]
    # Fetch the user
    user = User.find(:first, :conditions => ["id = ?", user_id])
    user_target = User.find(:first, :conditions => ["id = ?", user_id_target])
    # Locate invitation
    if user.friends.include?(user_target)
      Invite.delete!(user, user_target)
      flash[:notice] = "Friend relationship removed"
    else
      flash[:error] = "Users are not friends"
    end
  end
end
