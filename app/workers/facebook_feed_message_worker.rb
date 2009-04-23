class FacebookFeedMessageWorker < Workling::Base
  def post_activation(options)
    begin
      facebook_id = options[:facebook_id]
      facebook_session = options[:facebook_session]
      fb_user = Facebooker::User.new(facebook_id, facebook_session)
      FacebookAppPublisher.register_publish_action
      #puts FacebookAppPublisher.create_publish_action(fb_user)
      FacebookAppPublisher.deliver_action(fb_user)
    rescue Exception => e
      puts e.backtrace
    end
  end
end
