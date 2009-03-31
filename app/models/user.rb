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
end
