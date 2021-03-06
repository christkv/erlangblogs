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

    # Add the blog entries to be displayed
    @blog_entries = BlogEntry.paginate(:page => params[:page], :per_page => 20, :order => "date_published asc")
    # Set up the projects we want to show (dependent on the activity level)
    @most_active_projects = Project.most_active_projects(31, 5)    
  end
end
