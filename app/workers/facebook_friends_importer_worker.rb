# To change this template, choose Tools | Templates
# and open the template in the editor.

class FacebookFriendsImporterWorker < Workling::Base
  def import_friends(options)
    begin
      facebook_id = options[:facebook_id]
      facebook_session = options[:facebook_session]
      #facebook = facebook_session
      @fb_user = Facebooker::User.new(facebook_id, facebook_session)
      @fb_friends = @fb_user.friends!()
    rescue Exception => e
      puts e.backtrace
    end
  end
end
