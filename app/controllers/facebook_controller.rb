class FacebookController < ApplicationController
  before_filter :require_no_user, :only => [:link_user_accounts]

  def link_user_accounts
    if self.current_user.nil?
      #register with fb
      User.create_from_fb_connect(facebook_session.user)
    else
      #connect accounts
      self.current_user.link_fb_connect(facebook_session.user.id) unless self.current_user.fb_user_id == facebook_session.user.id
    end
    # create the user session and assign it as the current session
    @current_user_session = UserSession.new({:remember_me => "0", :openid_identifier => "", :login => "facebooker_#{facebook_session.user.uid}", :password => MD5.md5("facebooker_#{facebook_session.user.uid}").to_s})
    @current_user_session.save()
    # redirect_to '/'
    redirect_to account_url
  end
end
