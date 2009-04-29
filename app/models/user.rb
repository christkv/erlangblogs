require 'md5'

class User < ActiveRecord::Base
  # Handles the authentication of the user
  acts_as_authentic# :crypto_provider => Authlogic::CryptoProviders::BCrypt

  # network relationship with has_many_through and overrides
  acts_as_network :friends, :join_table => :invites,
                  :foreign_key => 'user_id', :association_foreign_key => 'user_id_target',
                  :conditions => ["is_accepted = ?", true]

  # Handles the indexing of the data for the user allowing for search
  acts_as_ferret :fields => [:firstname, :lastname, :login, :email]

  # User has an avatar
  has_attached_file :avatar, :styles => { :medium => "300x300>", :thumb => "100x100>" }

  # A User follows one or more projects
  has_and_belongs_to_many :project_follows, :class_name => "Project", :join_table => "project_follows"

  def is_following(user_id, project_id)
    # Validate presence of the project as a following
    Project.find_by_sql(["select * from project_follows pf, projects p where pf.user_id = ? and pf.project_id = ? and p.id = pf.project_id", user_id, project_id]).length == 0     
  end

  def signup!(params)
    self.login = params[:user][:login]
    self.email = params[:user][:email]
    save_without_session_maintenance
  end

  def activate!()
    self.active = true
    self.save()
  end
  
  def deliver_password_reset_instructions!
    reset_perishable_token!
    Notifier.deliver_password_reset_instructions(self)
  end  
  
  # Email notifications
  def deliver_password_reset_instructions!
    reset_perishable_token!
    Notifier.deliver_password_reset_instructions(self)
  end
  
  def deliver_activation_instructions!
    reset_perishable_token!
    Notifier.deliver_activation_instructions(self)
  end
  
  def deliver_activation_confirmation!
    reset_perishable_token!
    Notifier.deliver_activation_confirmation(self)
  end

  # Helper methods
  def active?
    active
  end

  #find the user in the database, first by the facebook user id and if that fails through the email hash
  def self.find_by_fb_user(fb_user)
    User.find_by_fb_user_id(fb_user.uid) || User.find_by_email_hash(fb_user.email_hashes)
  end
  #Take the data returned from facebook and create a new user from it.
  #We don't get the email from Facebook and because a facebooker can only login through Connect we just generate a unique login name for them.
  #If you were using username to display to people you might want to get them to select one after registering through Facebook Connect
  def self.create_from_fb_connect(fb_user)
    new_facebooker = User.new(:name => fb_user.name, :login => "facebooker_#{fb_user.uid}", :password => MD5.md5("facebooker_#{fb_user.uid}").to_s, :email => "", :single_access_token => "",
      :crypted_password => MD5.md5("facebooker_#{fb_user.uid}").to_s, :password_salt => "", :lastname => fb_user.last_name, :firstname => fb_user.first_name, :persistence_token => "",
      :active => true)
    new_facebooker.fb_user_id = fb_user.uid.to_i
    #We need to save without validations
    new_facebooker.save(false)
    new_facebooker.register_user_to_fb
  end

  #We are going to connect this user object with a facebook id. But only ever one account.
  def link_fb_connect(fb_user_id)
    unless fb_user_id.nil?
      #check for existing account
      existing_fb_user = User.find_by_fb_user_id(fb_user_id)
      #unlink the existing account
      unless existing_fb_user.nil?
        existing_fb_user.fb_user_id = nil
        existing_fb_user.save(false)
      end
      #link the new one
      self.fb_user_id = fb_user_id
      save(false)
    end
  end

  #The Facebook registers user method is going to send the users email hash and our account id to Facebook
  #We need this so Facebook can find friends on our local application even if they have not connect through connect
  #We hen use the email hash in the database to later identify a user from Facebook with a local user
  def register_user_to_fb
    users = {:email => email, :account_id => id}
    Facebooker::User.register([users])
    self.email_hash = Facebooker::User.hash_email(email)
    save(false)
  end
  def facebook_user?
    return !fb_user_id.nil? && fb_user_id > 0
  end
end
