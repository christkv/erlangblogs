class HomeController < ApplicationController

  def index
    puts "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
    puts params.inspect
    puts "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
    # If we are logged on using a facebook session then fetch the facebook users
    if !facebook_session.nil?
      #FacebookFriendsImporterWorker.asynch_import_friends({:facebook_id => '848740108', :facebook_session => facebook_session})
      #FacebookFeedMessageWorker.asynch_post_activation({:facebook_id => '848740108', :facebook_session => facebook_session})
      FacebookAppPublisher.register_publish_action
      FacebookAppPublisher.deliver_notification(facebook_session.user, facebook_session.user)
      #facebook = facebook_session
      #@fb_user = Facebooker::User.new('848740108')
      #@fb_friends = @fb_user.friends!()
    end
  end
end
