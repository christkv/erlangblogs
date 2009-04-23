class FacebookAppPublisher < Facebooker::Rails::Publisher
  # The new message templates are supported as well
  # First, create a method that contains your templates:
  # You may include multiple one line story templates and short story templates
  # but only one full story template
  #  Your most specific template should be first
  #
  # Before using, you must register your template by calling register. For this example
  #  You would call TestPublisher.register_publish_action
  #  Registering the template will store the template id returned from Facebook in the
  # facebook_templates table that is created when you create your first publisher
  def publish_action_template
    #one_line_story_template "{*actor*} did stuff with {*friend*}"
    #one_line_story_template "{*actor*} did stuff"
    #short_story_template "{*actor*} has a title {*friend*}", "Hello world"
    #short_story_template "{*actor*} has a title", render(:partial=>"short_body")
    #full_story_template "{*actor*} has a title {*friend*}", render(:partial=>"full_body")
    #action_links action_link("My text {*template_var*}","{*link_url*}")
    one_line_story_template "{*actor*} went for a {*distance*} run at {*location*}."
  end

  # To send a registered template, you need to create a method to set the data
  # The publisher will look up the template id from the facebook_templates table
  def publish_action(f)
    send_as :notification
    from f
    story_size SHORT # or ONE_LINE or FULL
    data :friend=>"Mike"
  end

  # Provide a from user to send a general notification
  # if from is nil, this will send an announcement
  def notification(to,f)
    send_as :notification
    recipients to
    from f
    fbml "Not"
  end

  def email(to,f)
    send_as :email
    recipients to
    from f
    title "Email"
    fbml 'text'
    text fbml
  end
  # This will render the profile in /users/profile.erb
  #   it will set @user to user_to_update in the template
  #  The mobile profile will be rendered from the app/views/test_publisher/_mobile.erb
  #   template
  def profile_update(user_to_update,user_with_session_to_use)
    send_as :profile
    from user_with_session_to_use
    to user_to_update
    profile render(:action=>"/users/profile",:assigns=>{:user=>user_to_update})
    profile_action "A string"
    mobile_profile render(:partial=>"mobile",:assigns=>{:user=>user_to_update})
  end

  #  Update the given handle ref with the content from a
  #   template
  def ref_update(user)
    send_as :ref
    from user
    fbml render(:action=>"/users/profile",:assigns=>{:user=>user_to_update})
    handle "a_ref_handle"
  end
end
